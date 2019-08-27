defmodule Box do
  @min_jaro_distance 0.9615

  def run do
    {:ok, boxes} = File.read("boxes.txt")
    boxes |> String.split("\n", trim: true) |> get_box()
  end

  defp get_box([box1 | boxes]) do
    if box2 = Enum.find(boxes, &(String.jaro_distance(&1, box1) > @min_jaro_distance)) do
      remove_differing_char(box1, box2)
    else
      get_box(boxes)
    end
  end

  defp get_box([]) do
    "Not found"
  end

  defp remove_differing_char(box1, box2) do
    Enum.zip(String.graphemes(box1), String.graphemes(box2))
    |> Enum.reject(fn {a, b} -> a != b end)
    |> Enum.flat_map(fn {a, _} -> [a] end)
  end
end

IO.puts "Box ID: #{Box.run}"
