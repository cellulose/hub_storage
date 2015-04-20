HubStorage
========

**HubStorage** adds a key/value storage mechenism to [Hub](http://github.com/cellulose/hub) with persistence using [PersistentStorage](http://github.com/cellulose/persistent_storage).

Adding HubStorage to your Hub allows remote runtime storage of key/value pairs. This may be useful for many purposes was developed with storing supplemental information about a point in the Hub.

Once started any request to Hub at the path specified during startup/configuration it will be handled by HubStorage.

*Note:* HubStorage requires that both Hub and Persistent Storage are running and setup respectively before starting. Please see their documentation for information about starting and setting up those modules.

## Options

The `:path` option is required and specifies the point in the Hub to bind to. This may also be configured in your application config file.

The `:type` option is used to specify the `@type` key for the path. Default: "hub_storage"

The `:values` option may be passed a key/value list to place at the `:path` during initialization. Default: []

## Examples

```elixir
iex> Hub.start
{:ok, #PID<0.130.0>}
iex> PersistentStorage.setup path: "/tmp/test"
:ok
iex> HubStorage.start path: [:some, :point]
{:ok, #PID<0.137.0>}
iex> Hub.request [:some, :point], [useful: :info]
{:changes, {"0513b7725c5436E67975FB3A13EB3BAA", 2},
 [some: [point: [useful: :info]]]}
```
