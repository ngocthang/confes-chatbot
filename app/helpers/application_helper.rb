module ApplicationHelper
  def get_status st
    st == 0 ? "pending" : "approved"
  end
end
