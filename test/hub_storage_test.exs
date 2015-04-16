defmodule HubStorageTest do
  use ExUnit.Case

  @point [:test, :point]
  @dev_point @point ++ [:devices]
  @path "/tmp/storage_test"

  @silly_path [:tests, :silly]
  @silly_data [goofy: :smiles]

  Hub.start
  HTTPotion.start

  test "HubStorage starts" do
    setup_and_start
    {ret, _pid} = HubStorage.start path: @point
    assert ret == :ok
  end

  test "Ensure point created and request is handled" do
    setup_and_start
    {ret, _pid} = HubStorage.start path: @dev_point
    assert ret == :ok
    {:changes, _, changes} = Hub.request @dev_point, @silly_data
    assert changes == [test: [point: [devices: [goofy: :smiles]]]]
  end

  defp setup_and_start do
    Hub.start
    File.rm_rf @path
    PersistentStorage.setup path: @path
  end
end
