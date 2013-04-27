ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
   if AdminUser.find(1).valid_password?('password')
        div :class => "blank_slate_container", :id => "dashboard_default_message" do
          span :class => "blank_slate" do
                span :class => "warning" do 
                    span "Please don't forget to change the " 
                    span link_to("default administrator password", edit_admin_admin_user_path(1))
                end
          end
        end
        br
    end

    columns do
      column do
        panel "Recent Orders" do
          ul do
            Order.order("created_at DESC").limit(5).map do |order|
              li link_to(order.uuid, admin_order_path(order))
            end
          end
        end
      end
    end
  end # content
end
