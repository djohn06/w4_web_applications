## Changes made in Phase 2 | 02 & 03 - Building Routes & Test-driving

#### Created new test case in app_spec:

```ruby
context "GET /" do
        it "contains a h1 title" do
            response = get('/')
            expect(response.body).to include('<h1>Hello!</h1>')
        end
```

#### Created 'views' folder and index.erb

**Within the index.erb file**

```html
<html>
  <head></head>
  <body>
    <h1>Hello!</h1>
  </body>
</html>
```

#### Updated app.rb to include '/' route

```ruby
  get '/' do
    return erb(:index)
  end
```

### These changes have been pushed into GitHub. New test in app_spec has passed.