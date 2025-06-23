defmodule HandleStackoverflowWeb.ErrorJSONTest do
  use HandleStackoverflowWeb.ConnCase, async: true

  test "renders 404" do
    assert HandleStackoverflowWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert HandleStackoverflowWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
