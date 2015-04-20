defmodule HubStorage do
  @moduledoc """
  **HubStorage** adds a key/value storage mechenism to [Hub](http://github.com/cellulose/hub) with persistence using [PersistentStorage](http://github.com/cellulose/persistent_storage).

  Adding HubStorage to your Hub allows remote runtime storage of key/value pairs. This may be useful for many purposes was developed with storing supplemental information about a point in the Hub.

  Once started any request to Hub at the path specified during startup/configuration it will be handled by HubStorage.

  *Note:* HubStorage requires that both Hub and Persistent Storage are running and setup respectively before starting. Please see their documentation for information about starting and setting up those modules.

  ## Options

  The `:path` option is required and specifies the point in the Hub to bind to.

  The `:type` option is used to specify the `@type` key for the path. Default: "hub_storage"

  The `:values` option may be passed a key/value list to place at the `:path` during initialization. Default: []

  ## Examples

  ```elixir
  # Start up dependencies
  iex> Hub.start
  {:ok, #PID<0.130.0>}
  iex> PersistentStorage.setup path: "/tmp/test"
  :ok

  # Start HubStorage
  iex> HubStorage.start path: [:some, :point]
  {:ok, #PID<0.137.0>}

  # Handling a request to path in Hub
  iex> Hub.request [:some, :point], [useful: :info]
  {:changes, {"0513b7725c5436E67975FB3A13EB3BAA", 2},
   [some: [point: [useful: :info]]]}
  ```
  """

  use GenServer

  @doc """
  Starts HubStorage GenServer.

  ## Options

  The `:path` option is required and specifies the point in the Hub to bind to.

  The `:type` option is used to specify the `@type` key for the path. Default: "hub_storage"

  The `:values` option may be passed a key/value list to place at the `:path` during initialization. Default: []

  ## Examples

  ```
  iex> HubStorage.start path: [:some, :point]

  iex> HubStorage.start path: [:some, :point], values: [initial: :data], type: "point_info"
  ```
  """
  def start(args) do
    GenServer.start __MODULE__, args, []
  end

  @doc false
  def init(args) do
    path = Dict.get(args, :path, nil)
    values = Dict.get(args, :values, [])
    type = Dict.get(args, :type, "hub_storage")

    case path do
      nil -> {:stop, :no_path}
      path ->
        #Retrieve previous information from PersistentStorage
        data = PersistentStorage.get(pstore_point(path), ["@type": type])

        #merge new values with Persistent data
        data = data ++ values

        #Setup the hub and manage the point
        Hub.put path, data
        Hub.master path

        {:ok, %{path: path}}
    end
  end

  @doc """
  Handles request to Hub at the path provided during `start/1`.

  Updates the Hub at the path with the params, then stores the params using
  PersistentStorage so it survises reboots of the system.
  """
  def handle_call({:request, path, params, _}, _, state) do
    # BUGBUG: Does Hub protect against attacks (ie: to much data)?
    reply = Hub.put path, params
    {{_,_}, updated} = Hub.fetch(Dict.get(state, :path))
    PersistentStorage.put pstore_point(Dict.get(state, :path)), updated
    {:reply, reply, state}
  end

  # Convert list of atoms to binaries
  defp binarify([h|t]), do: List.flatten [binarify(h), binarify(t)]
  defp binarify(a) when is_atom(a), do: Atom.to_string(a)
  defp binarify(o), do: o

  # Compute PersistentStorage file name
  defp sp_name(path) do
    Enum.join(binarify([:hub_storage | path]), "_")
  end

  # Compute PersistentStorage file name to atom
  defp pstore_point(path) do
    String.to_atom sp_name(path)
  end
end
