# GeoTaskTracker

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Predefined tokens:
- driver `SFMyNTY.g2gDYQFuBgAz1JQ8cwFiAeGH4A.ZZ5txN7IPlSNS1AszqhYLGFCJyhbzeIuuhZGz3wI6gE`
- manager `SFMyNTY.g2gDYQJuBgDBNJU8cwFiAeGH4A.LrhjGfLK0yyBiwQ4TH10gUK6AkpkLi9xiJ0pitMZpOg`

Create signed token:
```elixir
Phoenix.Token.sign(GeoTaskTrackerWeb.Endpoint, "user auth", user_id)
```
