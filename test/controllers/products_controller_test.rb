require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
    test 'render a list of products' do
        get products_path

        assert_response :success
        assert_select '.product', 2
    end

    test 'render a details of a product page' do
        # byebug
        get product_path(products(:ps4))

        assert_response :success
        assert_select '.title', 'PlayStation 4'
        assert_select '.price', '$299'
        assert_select '.description', 'The PlayStation 4 system is the successor to the PlayStation 3 system.'
    end

    test 'render a new product form' do
        get new_product_path

        assert_response :success
        assert_select 'input[name="product[title]"]'
        assert_select 'input[name="product[price]"]'
        assert_select 'textarea[name="product[description]"]'
    end

    test 'allow to create a new product' do
        post products_path, params: { product: { title: 'PlayStation 5', price: 399, description: 'The PlayStation 5 system is the successor to the PlayStation 4 system.' } }

        assert_redirected_to products_path
        assert_equal 'Product created successfully.', flash[:notice]
    end

    test 'does not allow to create a new product' do
        post products_path, params: { product: { price: 399, description: 'The PlayStation 5 system is the successor to the PlayStation 4 system.' } }

        assert_response :unprocessable_entity
    end

    test 'render a edit product form' do
        get edit_product_path(products(:ps4))

        assert_response :success
        assert_select 'input[name="product[title]"]'
        assert_select 'input[name="product[price]"]'
        assert_select 'textarea[name="product[description]"]'
    end

    test 'allow to edit a product' do
        patch product_path(products(:ps4)), params: {
            product: {
                title: 'PlayStation 50'
            }
        }

        assert_redirected_to products_path
        assert_equal 'Product updated successfully.', flash[:notice]
    end

    test 'can delete a product' do
        assert_difference('Product.count', -1) do
            delete product_path(products(:ps4))
        end

        assert_redirected_to products_path
        assert_equal 'Product deleted successfully.', flash[:notice]
    end
end