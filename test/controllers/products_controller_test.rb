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

	test 'render a new product form' do
		get new_product_path

		assert_response :success
		assert_select 'form'
	end

	test 'allow to create a new product' do
		post products_path, params: {
			product: {
				title: 'Mouse Inalambrico',
				description: 'Bateria de carga dañada, necesita cambio',
				price: 20000
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
end