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

## Contributing

We appreciate any contribution to Cellulose Projects, so check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide for more information. We usually keep a list of features and bugs [in the issue tracker][2].

## Building documentation

Building the documentation requires [ex_doc](https://github.com/elixir-lang/ex_doc) to be installed. Please refer to
their README for installation instructions and usage instructions.

## License

The MIT License (MIT)

Copyright (c) 2014 Chris Dutton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
