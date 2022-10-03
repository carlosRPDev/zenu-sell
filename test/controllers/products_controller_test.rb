require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
  end

  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 12
    assert_select '.category', 10
  end

  test 'render a list of products filtered by category' do
    get products_path(category_id: categories(:computers).id)

    assert_response :success
    assert_select '.product', 5
    assert_select '.category', 10
  end

  test 'render a list of products filtered by min_price and max_price' do
    get products_path(min_price: 100000, max_price: 210000)

    assert_response :success
    assert_select '.product', 8
    assert_select 'h2', 'Tv Samsung 43 pulgadas'
    assert_select 'h2', 'Teclado Mecanico Keychrom K2 v2'
  end

  test 'search a productby query_text' do
    get products_path(query_text: 'PS4 Fat')

    assert_response :success
    assert_select '.product', 1
    assert_select 'h2', 'PS4 Fat'
  end

  test 'sort products by expensive price first' do
    get products_path(order_by: 'expensive')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'Seat Panda clásico'
  end

  test 'sort products by cheapest price first' do
    get products_path(order_by: 'cheapest')

    assert_response :success
    assert_select '.product', 12
    assert_select '.products .product:first-child h2', 'El hobbit'
  end

  test 'render a detailed product page' do
    get product_path(products(:TecladoMecanico))

    assert_response :success
    assert_select '.title', 'Teclado Mecanico Keychrom K2 v2'
    assert_select '.description', 'Teclado mecanico Keychrom k2 v2 con daño en la tecla enter'
    assert_select '.price', '200000'
  end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allows to create a new product' do
    post products_path, params: {
      product: {
        title: 'Mouse Inalambrico',
        description: 'Bateria de carga dañada, necesita cambio',
        price: 20000,
        category_id: categories(:computers).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
  end

  test 'does not allow to create a new product with empty fiellds' do
    post products_path, params: {
      product: {
        title: '',
        description: 'Bateria de carga dañada, necesita cambio',
        price: 20000
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render an edit product form' do
    get edit_product_path(products(:TecladoMecanico))

    assert_response :success
    assert_select 'form'
  end

  test 'allows to update a product' do
    patch product_path(products(:TecladoMecanico)), params: {
      product: {
        price: 30000
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end

  test 'does npt allow to update a product with an invalid field' do
    patch product_path(products(:TecladoMecanico)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:TecladoMecanico))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end
end