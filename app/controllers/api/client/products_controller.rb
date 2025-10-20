class Api::Client::ProductsController < Api::Client::BaseClientController
  skip_before_action :authenticate_account_user!

  def index
    page = params[:page].to_i >= 1 ? params[:page].to_i : 1
    per_page = 5
    query = params[:query].to_s.strip
    min_price = params[:min_price].presence&.to_f
    max_price = params[:max_price].presence&.to_f
    attribute_value_ids = params[:attribute_value_ids].presence
    category_ids = params[:categories_ids].presence
    sort = params[:sort].presence

    cache_key = [
      "product_page=#{page}",
      "per_page=#{per_page}",
      "query=#{query.presence || 'none'}",
      "min_price=#{min_price || 'none'}",
      "max_price=#{max_price || 'none'}",
      "attribute_value_ids=#{attribute_value_ids&.join(',') || 'none'}",
      "category_ids=#{category_ids&.join(',') || 'none'}",
      "sort=#{sort || 'none'}"
    ].join("&")

    Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      must_clauses = []

      # --- Text search ---
      if query.present?
        must_clauses << {
          multi_match: {
            query: query,
            fields: %w[name brand description slug],
            fuzziness: "AUTO"
          }
        }
      end

      # --- Price range ---
      if min_price.present? || max_price.present?
        range_filter = {}
        range_filter[:gte] = min_price if min_price.present?
        range_filter[:lte] = max_price if max_price.present?

        must_clauses << {
          nested: {
            path: "product_variants",
            query: {
              range: { "product_variants.price": range_filter }
            }
          }
        }
      end

      # --- Attribute values ---
      if attribute_value_ids.present?
        must_clauses << {
          nested: {
            path: "product_variants.attribute_values",
            query: {
              bool: {
                should: attribute_value_ids.map { |id| { term: { "product_variants.attribute_values.id": id } } },
                minimum_should_match: 1
              }
            }
          }
        }
      end

      # --- Categories (with ancestry) ---
      if category_ids.present?
        expanded_ids = Category.where(id: category_ids).map(&:subtree_ids).flatten.uniq
        must_clauses << {
          nested: {
            path: "categories",
            query: {
              terms: { "categories.id": expanded_ids.map(&:to_i) }
            }
          }
        }
      end

      # --- Sort options ---
      sort_clause =
        case sort
        when "price_asc"
          [
            {
              "product_variants.price": {
                order: "asc",
                mode: "min",
                nested: { path: "product_variants" }
              }
            }
          ]
        when "price_desc"
          [
            {
              "product_variants.price": {
                order: "desc",
                mode: "max",
                nested: { path: "product_variants" }
              }
            }
          ]
        else
          [{ created_at: { order: :desc } }]
        end

      # --- Elasticsearch query ---
      search_body = {
        from: (page - 1) * per_page,
        size: per_page,
        query: {
          bool: {
            must: must_clauses.presence || [{ match_all: {} }]
          }
        },
        sort: sort_clause
      }

      results = Product.search(search_body)
      meta = es_pagination_meta(results.response, page, per_page)

      serialized_products = ActiveModelSerializers::SerializableResource.new(
        results.records,
        each_serializer: ProductSerializer
      ).as_json

      {
        data: { products: serialized_products },
        meta: meta
      }
    end.then do |cached_response|
      render_response(
        data: cached_response[:data],
        message: "Get all products successfully",
        status: 200,
        meta: cached_response[:meta]
      )
    end
  end

  def show
    product = Product.without_deleted.find_by!(slug: params[:id])
    categories = product.categories.pluck(:id)
    related_products = Product
                         .joins(:categories)
                         .where(categories: { id: categories })
                         .where.not(id: product.id)
                         .distinct
                         .order(total_sold: :desc)
                         .limit(5)

    render_response(
      data: {
        product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer),
        related_products: related_products ? ActiveModelSerializers::SerializableResource.new(related_products, serializer: ProductSerializer) : nil
      },
      message: "Get product successfully!",
      status: 200
    )
  end
end
