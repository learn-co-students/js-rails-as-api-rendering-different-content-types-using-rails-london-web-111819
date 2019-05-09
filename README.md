# Rendering Different Content Types in Rails

## Learning Goals

- Override the default Rails view
- Render HTML from a Rails controller
- Render plain text from a Rails controller
- Render JSON from a Rails controller

## Introduction

In the previous lesson, we revisited the default Rails MVC structure, and at the
end, an ERB file was rendered. Rails, however, can render multiple types of
content. In this code-along, we're going to take a look at a few of the options,
as well as explore the use of `respond_to` while continuing to expand on the
our bird watching application.

To follow along, run `rails db:migrate` and `rails db:seed` to set up your
database and example data.

## Overriding the Default Rails View 

Leaving off from the solution of the last lesson, the`index` action rendered all
birds:

```ruby
class BirdsController < ApplicationController
  def index
    @birds = Bird.all
  end
end
```

And we know that this is the same as explicitly stating:

```ruby
class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render 'birds/index.html.erb'
  end
end
```

But we aren't restricted to displaying ERB. We can indicate to `render` what type
of content to render. The simplest is plain text.

### Render Plain Text From a Controller

To render plain text from a Rails controller, you specify `plain:`, followed by
the text you want to display:

```ruby
class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render plain: "Hello #{@birds[3].name}"
  end
end
```

In the browser, this displays as:

```text
Hello Mourning Dove
```

This isn't very fancy, but **_this is actually enough for us to start using our
JavaScript skills and access with a fetch request_**. To check this out
yourself, in this code-along, there is an HTML file, `example_frontend.html`.
Replace `BirdsController` with the code above, start up the Rails server (don't
forget to migrate!) and open `example_frontend.html`. From the browser's
console, with the Rails server running, run the following:

```js
fetch('http://localhost:3000/birds').then(response => response.text()).then(text => console.log(text))
// > Promise {<pending>}
Hello Mourning Dove
```

> **Notice**: On resolution of the `fetch()` request here, in the first
`.then()`, `response.text()` is called, since we're handling plain text.

We haven't really escaped the MVC structure of Rails, but we're no longer using
the ERB view, nor are we really _viewing_ in the same way we were before.

We've actually requested data, and since it is just plain text, JavaScript can
handle that. But, Rails has one better.

### Render JSON From a Controller

To render _JSON_ from a Rails controller, you specify `json:` followed most
often by a hast or array. In our case, we've already got a collection of data,
so we can simply write:

```ruby
class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render json: @birds
  end
end
```

With the Rails server running, check out `http://localhost:3000/birds`. You
should see that Rails has output all the data available from all the `Bird`
records!

```js
[
  {
      "id": 1,
      "name": "Black-Capped Chickadee",
      "species": "Poecile Atricapillus",
      "created_at": "2019-05-09T11:07:58.188Z",
      "updated_at": "2019-05-09T11:07:58.188Z"
    },
    {
      "id": 2,
      "name": "Grackle",
      "species": "Quiscalus Quiscula",
      "created_at": "2019-05-09T11:07:58.195Z",
      "updated_at": "2019-05-09T11:07:58.195Z"
    },
    {
      "id": 3,
      "name": "Common Starling",
      "species": "Sturnus Vulgaris",
      "created_at": "2019-05-09T11:07:58.199Z",
      "updated_at": "2019-05-09T11:07:58.199Z"
    },
    {
      "id": 4,
      "name": "Mourning Dove",
      "species": "Zenaida Macroura",
      "created_at": "2019-05-09T11:07:58.205Z",
      "updated_at": "2019-05-09T11:07:58.205Z"
    }
]
```

Going back to our `example_frontend.html`, we could send another `fetch()`
request to the same place, only this time, since we're handling JSON, we'll swap
out `text()` for `json()`:

```js
fetch('http://localhost:3000/birds').then(response => response.json()).then(object => console.log(object))
// > Promise {<pending>}
 > [{…}, {…}, {…}, {…}]

// 0: {id: 1, name: "Black-Capped Chickadee", species: "Poecile Atricapillus", created_at: "2019-05-09T11:07:58.188Z", updated_at: "2019-05-09T11:07:58.188Z"}
// 1: {id: 2, name: "Grackle", species: "Quiscalus Quiscula", created_at: "2019-05-09T11:07:58.195Z", updated_at: "2019-05-09T11:07:58.195Z"}
// 2: {id: 3, name: "Common Starling", species: "Sturnus Vulgaris", created_at: "2019-05-09T11:07:58.199Z", updated_at: "2019-05-09T11:07:58.199Z"}
// 3: {id: 4, name: "Mourning Dove", species: "Zenaida Macroura", created_at: "2019-05-09T11:07:58.205Z", updated_at: "2019-05-09T11:07:58.205Z"}
```

Four birds!

You may also often see more detailed nesting in the `render json:` statement:

```ruby
class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render json: { birds: @birds, messages: ['Hello Birds', 'Goodbye Birds'] }
  end
end
```

Notice that the above would alter the structure of data being rendered. Rather
than an array of four birds, an object with two keys, each pointing to an array
would be rendered instead. We will explore shaping our data in greater detail in
upcoming lessons, but it is a critical concept to consider. Well structured data
can _make your code simpler_.

## Conclusion

Let's take a step back and consider what all this means because this is
actually huge! Now that you know that Rails can render JSON, you have the
ability to create entirely independent JavaScript frontends that can communicate
with Rails backends!