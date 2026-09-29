module ApplicationHelper
  def flash_class(type)
    if type == "notice"
      "alert-success"
    else
      "alert-danger"
    end
  end
end
