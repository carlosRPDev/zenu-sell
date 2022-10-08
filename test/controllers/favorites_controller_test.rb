require "test_helper"

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @tv = products(:tv)
    @Teclado_mecanico = products(:TecladoMecanico)
  end

  test "should return my favorites" do
    get favorites_url

    assert_response :success
  end

  test "should create favorite" do
    assert_difference('Favorite.count', 1) do
      post favorites_url(product_id: @tv.id)
    end
    
    assert_redirected_to product_path(@tv)
  end

  test "should unfavorite" do
    assert_difference('Favorite.count', -1) do
      delete favorite_url(@Teclado_mecanico.id)
    end
    
    assert_redirected_to product_path(@Teclado_mecanico)
  end
end
