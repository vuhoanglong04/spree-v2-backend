require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it 'has many product_categories' do
      category = create(:category)
      expect(category).to respond_to(:product_categories)
      expect(category.product_categories).to be_a(ActiveRecord::Associations::CollectionProxy)
    end

    it 'has many products through product_categories' do
      category = create(:category)
      expect(category).to respond_to(:products)
      expect(category.products).to be_a(ActiveRecord::Associations::CollectionProxy)
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of slug' do
      category = build(:category, slug: nil)
      expect(category).not_to be_valid
      expect(category.errors[:slug]).to include("can't be blank")
    end

    it 'validates uniqueness of name (case insensitive)' do
      base_name = "UniqueCat #{SecureRandom.hex(3)}"
      create(:category, name: base_name, slug: base_name.parameterize)
      duplicate = build(:category, name: base_name.upcase, slug: "#{base_name.parameterize}-2")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to be_present
    end

    it 'validates uniqueness of slug (case insensitive)' do
      base_slug = "unique-slug-#{SecureRandom.hex(3)}"
      create(:category, name: "Category #{base_slug}", slug: base_slug)
      duplicate = build(:category, name: "Category 2 #{base_slug}", slug: base_slug.upcase)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug]).to be_present
    end
  end

  describe 'acts_as_paranoid' do
    it 'soft deletes the category' do
      category = create(:category)
      category.destroy

      expect(Category.find_by(id: category.id)).to be_nil
      expect(Category.with_deleted.find_by(id: category.id)).to be_present
      expect(category.deleted_at).to be_present
    end

    it 'can restore a soft deleted category' do
      category = create(:category)
      category.destroy
      category.restore

      expect(Category.find_by(id: category.id)).to be_present
      expect(category.deleted_at).to be_nil
    end
  end

  describe 'ancestry (tree structure)' do
    it 'allows creating a root category' do
      category = create(:category, name: "Root Category", slug: "root-category")

      expect(category.root?).to be true
      expect(category.parent).to be_nil
    end

    it 'allows creating a child category' do
      parent = create(:category, name: "Parent", slug: "parent")
      child = create(:category, name: "Child", slug: "child", parent: parent)

      expect(child.parent).to eq(parent)
      expect(parent.children).to include(child)
    end

    it 'allows creating nested categories' do
      grandparent = create(:category, name: "Grandparent", slug: "grandparent")
      parent = create(:category, name: "Parent", slug: "parent", parent: grandparent)
      child = create(:category, name: "Child", slug: "child", parent: parent)

      expect(child.ancestors).to include(parent, grandparent)
      expect(grandparent.descendants).to include(parent, child)
    end

    it 'returns all descendants' do
      parent = create(:category, name: "Parent", slug: "parent")
      child1 = create(:category, name: "Child 1", slug: "child-1", parent: parent)
      child2 = create(:category, name: "Child 2", slug: "child-2", parent: parent)
      grandchild = create(:category, name: "Grandchild", slug: "grandchild", parent: child1)

      expect(parent.descendants).to match_array([ child1, child2, grandchild ])
    end
  end

  describe 'product associations' do
    let(:category) { create(:category) }
    let(:product) { create(:product) }

    it 'can have many products through product_categories' do
      product_category = create(:product_category, category: category, product: product)

      expect(category.products).to include(product)
      expect(category.product_categories).to include(product_category)
    end

    it 'can have multiple products' do
      product1 = create(:product)
      product2 = create(:product)

      create(:product_category, category: category, product: product1)
      create(:product_category, category: category, product: product2)

      expect(category.products.count).to eq(2)
      expect(category.products).to include(product1, product2)
    end
  end

  describe 'factory' do
    it 'creates a valid category' do
      category = build(:category)
      expect(category).to be_valid
    end

    it 'creates a category with default attributes' do
      category = create(:category)

      expect(category.name).to be_present
      expect(category.slug).to be_present
      expect(category.position).to eq(0)
    end
  end
end
