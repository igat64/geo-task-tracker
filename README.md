# GeoTaskTracker
Geo-based tasks tracker

Build an API to work with geo-based tasks. Use Elixir and PostgreSQL (recommended). All API endpoints should work with json body (not form-data). The result should be available as Github repo with commit history and the code covered by tests. Please commit the significant step to git, and we want to see how you evolved the source code.

Each request needs to be **authorized by token**. You can use pre-defined tokens stored on the backend side. Operate with tokens for two types of users:

1. Manager
1. Driver

Create tokens for more drivers and managers, not just 1-1.

Each task can be in 3 states:

1. New (Created task)
1. Assigned (The driver has picked this task)
1. Done (Task marked as completed by the driver)

### Access

* Manager can create tasks with two geo locations pickup and delivery
* Driver can get the list of tasks nearby (sorted by distance) by sending his current location 
* Driver can change the status of the task (to assigned/done). 
* Drivers can't create/delete tasks. 
* Managers can't change task status.

### Workflow:

1. The manager creates a task with location pickup [lat1, long1] and delivery [lat2,long2]
1. The driver gets the list of the nearest tasks by submitting current location [lat, long]
1. Driver picks one task from the list (the task becomes assigned)
1. Driver finishes the task (becomes done)

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Configure PostresSQL credentials in the `config/dev.exs`
  * Create and migrate your database with `mix ecto.setup`
  * Populate database `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Before running test you need provide access to the local database in the `config/test.exs` and then run `mix test`

Predefined tokens:
- driver  (`id: 1`) `SFMyNTY.g2gDYQFuBgA2dxpDcwFiAeGH4A.dQtg9T0yJd7ded3yoJcX0KeEV0fIoGLCj0dQNlEOG6A`
- manager (`id: 2`) `SFMyNTY.g2gDYQJuBgAboxhDcwFiAeGH4A.e9e7koBLfZL0pBQznZLtDoXgscZQ1nAL6ByxNdPBvIo`

Create signed token in the iex session (`iex -S mix`) if needed:
```elixir
Phoenix.Token.sign(GeoTaskTrackerWeb.Endpoint, "user", user_id, max_age: 31557600)
```

Create task

```bash
curl --location --request POST 'localhost:4000/tasks' \
--header 'Authorization: SFMyNTY.g2gDYQJuBgAboxhDcwFiAeGH4A.e9e7koBLfZL0pBQznZLtDoXgscZQ1nAL6ByxNdPBvIo' \
--header 'Content-Type: application/json' \
--data-raw '{
	"title": "Haul the cargo",
	"pickup_point": {
		"lat": 0,
		"lon": 90
	},
	"delivery_point": {
		"lat": 0,
		"lon": -90
	}
}'
```

Pickup task

```bash
curl --location --request POST 'localhost:4000/tasks/1/pickup' \
--header 'Authorization: SFMyNTY.g2gDYQFuBgA2dxpDcwFiAeGH4A.dQtg9T0yJd7ded3yoJcX0KeEV0fIoGLCj0dQNlEOG6A' \
--data-raw ''
```

Complete task

```bash
curl --location --request POST 'localhost:4000/tasks/1/complete' \
--header 'Authorization: SFMyNTY.g2gDYQFuBgA2dxpDcwFiAeGH4A.dQtg9T0yJd7ded3yoJcX0KeEV0fIoGLCj0dQNlEOG6A' \
--data-raw ''
```

Search nearby

```bash
curl --location --request GET 'localhost:4000/tasks/nearby/53.21/26.12' \
--header 'Authorization: SFMyNTY.g2gDYQFuBgA2dxpDcwFiAeGH4A.dQtg9T0yJd7ded3yoJcX0KeEV0fIoGLCj0dQNlEOG6A' \
--data-raw ''
```

Delete task

```bash
curl --location --request DELETE 'localhost:4000/tasks/24' \
--header 'Authorization: SFMyNTY.g2gDYQJuBgAboxhDcwFiAeGH4A.e9e7koBLfZL0pBQznZLtDoXgscZQ1nAL6ByxNdPBvIo' \
--data-raw ''
```