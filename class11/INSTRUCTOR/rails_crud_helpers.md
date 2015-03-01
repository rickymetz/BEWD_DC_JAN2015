# Rails CRUD

**Objectives:**

* Create a one-model CRUD app, fully featured with create, read, update, and destroy capabilities.
* Streamline development using Rails helpers.
* Understand basic Rails security features.

## Shortcuts

Rails offers shorthand names for many common commands. We'll be using the following shorthands today:

* `rails server` --> `rails s`
* `rails console` --> `rails c`
* `rails generate` --> `rails g`
* `rails dbconsole` --> `rails db`

## Part 1) C/R with helpers

**1. Make a new Rails app** called "muppets_app", then initialize the database:

```
rails new muppets_app -d postgresql
cd muppets_app
rake db:create
```

Use `rails db` to confirm your newly created database through the PSQL console.

---

**2. Generate a migration** for the "muppets" table. Let's use some additional shorthand that writes the entire migration for us:

```
rails g migration CreateMuppets name:string image_url:string
```

Open the newly-created migration file in the `db/migrate/` folder. Our migration should be filled in for us:

```
class CreateMuppets < ActiveRecord::Migration
  def change
    create_table :muppets do |t|
      t.string :name
      t.string :image_url
    end
  end
end
```

Run the migration:

```
rake db:migrate
```

---

**3. Setup a model**

Model in `app/models/muppet.rb`:

```
class Muppet < ActiveRecord::Base
end
```

Now add some seeds. Running `destroy_all` as part of your seeds file is a good way to always seed a fresh database.

Seeds in `db/seeds.rb`:

```
Muppet.destroy_all
Muppet.create([
  {name: 'Kermit', image_url: 'http://img1.wikia.nocookie.net/__cb20141006114333/disney/images/9/98/Kermit-two1.jpg'},
  {name: 'Piggy', image_url: 'http://image.gala.de/v1/cms/oh/miss-piggy_4839287-ORIGINAL-original.jpg'},
  {name: 'Fozzie', image_url: 'http://img2.wikia.nocookie.net/__cb20120410231906/muppet/images/b/b5/Fozzie2.jpg'}
])
```

Seed your database, then go into PSQL console to confirm your database setup:

```
rake db:seed
rails db
```

---

**4. Setup routes** for all model actions (creating, reading, updating, and destroying). There are seven basic routing actions that are *so* common, that Rails has condensed them down into a single `resources :name` command that we specify in our routes file:

In `config/routes.rb`:

```
resources :muppets
```

To see the current state of all generated routes within our application, run the incredibly handy `rake routes` command:

```
rake routes

  Prefix Verb   URI Pattern              Controller#Action
    muppets GET    /muppets(.:format)          muppets#index
            POST   /muppets(.:format)          muppets#create
 new_muppet GET    /muppets/new(.:format)      muppets#new
edit_muppet GET    /muppets/:id/edit(.:format) muppets#edit
     muppet GET    /muppets/:id(.:format)      muppets#show
            PATCH  /muppets/:id(.:format)      muppets#update
            PUT    /muppets/:id(.:format)      muppets#update
            DELETE /muppets/:id(.:format)      muppets#destroy
```

We can see that Rails has automatically configured all `/muppets` route resources for us. Neat! Okay, let's run the server:

```
rails s
```

---

**5. Setup a controller** with empty actions that service all muppets routes. Get to know this basic controller structure; you'll be using it a lot.

In `app/controllers/muppets_controller.rb`:

``` 
class MuppetsController < ApplicationController
	def index
	end

	def show
	end
	
	def new
	end
	
	def create
	end
	
	def edit
	end
	
	def update
	end
	
	def destroy
	end
end
```

---

**6. Setup your "index" controller/view**. Guess what? You don't actually *need* a `render` command in your controller action. Rails will assume a controller renders a view with the same name.

Controller action:

```
def index
  @muppets = Muppet.all
end
```

View in `app/views/muppets/index.html.erb`:

```
 <h1>Muppets</h1>

 <ul>
 <% @muppets.each do |muppet| %>
   <li><%= link_to muppet.name, muppet_path(muppet) %></li>
 <% end %>
 </ul>
 
 <%= link_to 'Add a muppet', new_muppet_path %>
```

We used two fancy features here:

- [Path helpers](http://guides.rubyonrails.org/routing.html#path-and-url-helpers): `muppet_path(muppet)`
- [Link helpers](http://guides.rubyonrails.org/getting_started.html#adding-links): `link_to 'Label', 'url'`

Path helpers are very important. They build upon the prefix names provided by `rake routes`. Any resource path may be accessed as `[prefix]_path`.

---

**7. Setup your "show" controller/view**

Controller action:

```
def show
  @muppet = Muppet.find(params[:id])
end
```

View in `app/views/muppets/show.html.erb`:

```
 <p><%= link_to "Muppets", muppets_path %> / <%= @muppet.name %></p>  
 <h1><%= @muppet.name %></h1>
 <img src="<%= @muppet.image_url %>">
```

---

**8. Setup your "new" controller/view**

Controller action:

```
def new
  @muppet = Muppet.new
end
```

View in `app/views/muppets/new.html.erb`:

```
 <h1>Add a muppet</h1>
 
 <%= form_for @muppet do |f| %>
 	<%= f.label :name %>
 	<%= f.text_field :name %>
 	
 	<%= f.label :image_url %>
 	<%= f.text_field :image_url %>
 	
 	<%= f.submit %>
 <% end %>
```

This time our view is using Rails form helpers. These helpers build a form for our model, and automatically configure the form's path and authenticity token. The form is configured to submit all data organized around a `params[:muppet]` hash.

---

**9. Setup your "create" controller/view**

Controller action:

```
def create
  @muppet = Muppet.create(params[:muppet])
  redirect_to @muppet
end

 # ERROR!!!
 # ActiveModel::ForbiddenAttributesError in MuppetsController#create
```

Wat?! Why can't we create a muppet using the hash available in params? This is a security feature of Rails: params could include extra fields that have been maliciously added to the form. This extra data could be harmful, therefore Rails requires us to *whitelist* fields that are allowed through form submissions.

Whitelisting is done using *strong parameters* configuration (don't worry about that `private` line for now...)

```
def create
  @muppet = Muppet.create(muppet_params)
  redirect_to @muppet
end

... other methods ...

private

def muppet_params
  params.require(:muppet).permit(:name, :image_url)
end
```

## Part 2) U/D at last

**1. Add an "edit" link** at the end of the "show" view:

In `app/muppets/show.html.erb`:

```
 <p><%= link_to 'Edit', edit_muppet_path(@muppet) %></p>
```

**2. Setup your "edit" controller/view**

Controller action:

```
def edit
  @muppet = Muppet.find(params[:id])
end
```

View in `app/views/muppets/edit.html.erb`:

```
 <h1>Edit <%= @muppet.name %></h1>
 
 <%= form_for @muppet do |f| %>
 	<%= f.label :name %>
 	<%= f.text_field :name %>
 	
 	<%= f.label :image_url %>
 	<%= f.text_field :image_url %>
 	
 	<%= f.submit %>
 <% end %>
```

Wait a second... that's the *exact same* form as the "new" action! It's certainly not DRY to have two copies of the same form floating around, so let's break that form out into it's own *view partial* that is included by both the "new" and "edit" views:

Partial view `app/views/muppets/_form.html.erb`:

```
 <%= form_for @muppet do |f| %>
 	<%= f.label :name %>
 	<%= f.text_field :name %>
 	
 	<%= f.label :image_url %>
 	<%= f.text_field :image_url %>
 	
 	<%= f.submit %>
 <% end %>
```

View `app/views/muppets/new.html.erb`:

```
 <h1>Add a muppet</h1>
 <%= render 'form' %>
```

View `app/views/muppets/edit.html.erb`:

```
 <h1>Edit <%= @muppet.name %></h1>
 <%= render 'form' %>
```

**3. Setup your "update" controller**

Controller action:

```
def update
  @muppet = Muppet.find(params[:id])
  @muppet.update(muppet_params)
  redirect_to @muppet
end
```

**4. The Destroyer of Muppets**

Controller action:

```
def destroy
  @muppet = Muppet.find(params[:id])
  @muppet.destroy
  redirect_to muppets_path
end
```

As for the view, there are a few ways to add a "destroy" button. The quick and dirty solution is with a Rails DELETE link... just put the following at the end of your muppets "show" view:

```
 <p><%= link_to 'Destroy', muppet_path(@muppet), :method => :delete, :'data-confirm' => 'Are you sure?' %></p>
```

Neat! That triggers a cool little confirmation alert, and then destroys our muppet once we accept the action. Ohhhh, Ahhhhh...

Okay, now that we're done being impressed, let's talk about the shortcomings here: this solution is entirely dependent on front-end JavaScript that Rails gives us. If JavaScript is disabled (or encounters errors) on the page, then these faux-DELETE links don't work. Plus, alert boxes are a pretty crude user experience. While these DELETE links are handy for getting your app up and running, they're not very elegant as part of a finished product.

A more robust solution for setting up "destroy" button actions uses a form:

```
<%= form_for @muppet, :method => :delete do |f| %>
  <%= f.submit 'Destroy' %>
<% end %>
```

While this approach doesn't provide any freebie confirmation dialog, it does reliably submit a DELETE request without relying on front-end JavaScript. With a bit of FE code, it would be pretty easy to build a basic modal confirmation atop this form.