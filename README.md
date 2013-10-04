This sample will cover about Strong Paramenter
##Setup
```sh
$ rails g scaffold Product name:string description:string category_id:integer
$ rails g scaffold Category name:string
$ rake db:create
$ rake db:migrate
$ rails s
```
##strong_parameters with single table
###Model
`app/model/product.rb`
```ruby
class Product < ActiveRecord::Base
end  
```
###Controller
`app/controllers/products_controller.rb`
```ruby
before_action :set_product, only: [:show, :edit, :create, :update]              # Rails 4 
```
`before_filter :set_product, only: [:show, :edit, :create, :update]` if you're using Rails 3
```ruby
.
.
.

 private                                                                                                                                                                                                    
 # Use callbacks to share common setup or constraints between actions.                                                                                                                                     
 def set_product                                                                                                                                                                                          
   @product = Product.find(params[:id])                                                                                                                                                                   
 end                                                                                                                                                                                                      
                                                                                                                                                                                                          
 # Never trust parameters from the scary internet, only allow the white list through.                                                                                                                     
 def product_params                                                                                                                                                                                       
   params.require(:product).permit(:name, :description)   #Permit which column you want to add to database, 
                                                          #value is nil when you not permit some column.                                                                                                                                                      
 end 
```


##strong_parameters with accept_nested_attributes
###Model
####Parent model
`app/model/category.rb`
```ruby
class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy
  accepts_nested_attributes_for :products 
end
```
####Children model
`app/model/product.rb`
```ruby
class Product < ActiveRecord::Base                                                                                                                                                                              
  belongs_to :category                                       
end  
```

####Controller
`app/controllers/categoires_controller.rb`
```ruby
before_action :set_category, only: [:show, :edit, :update, :destroy]
def new
  @category = Category.new
  3.times {@category.products.build}         # For example 1 category has 3 products 
end
.
.
.
private
# Use callbacks to share common setup or constraints between actions.
def set_category
  @category = Category.find(params[:id])
end
def category_params
  params.require(:category).permit(:name, products_attributes: [:id,:name])  #Add `id` to use when edit product records
end
```

####View
`app/views/categoires/_form.html.erb`
```erb
.
.
<div class="field">
    <%= f.label :name, "Category Name:" %><br>
    <%= f.text_field :name %>
  </div>
  <%= f.fields_for :products do |pr| %>
    <p>
      <%= pr.label :name, "Product Name:" %>
      <%= pr.text_field :name %>
      <%= pr.hidden_field :id %>        #Using when edit, to identify record is editing. Not create new record
    </p>
  <% end %>
.
.

```

###References
http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html <br/>
http://railscasts.com/episodes/196-nested-model-form-part-1?view=asciicast
