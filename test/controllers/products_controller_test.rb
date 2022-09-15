require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
	test 'render a list of products' do
		get products_path

		assert_response :success
		assert_select '.product', 2
	end

	test 'render a detailed product page' do
		get product_path(products(:TecladoMecanico))

		assert_response :success
		assert_select '.title', 'Teclado Mecanico Keychrom K2 v2'
		assert_select '.description', 'Teclado mecanico Keychrom k2 v2 con daño en la tecla enter'
		assert_select '.price', '200000'
	end
end