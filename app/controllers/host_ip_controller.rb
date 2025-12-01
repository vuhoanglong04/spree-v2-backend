class HostIpController < ApplicationController
  def host_ip
    ip = Socket.ip_address_list.detect(&:ipv4_private?)&.ip_address
    render plain: "Host IP: #{ip || 'unknown'}"
  end
end
