defmodule Box do
  def run do
    {:ok, boxes} = File.read("boxes.txt")
    boxes |> String.split("\n", trim: true) |> compute_checksum(0, 0)
  end

  defp compute_checksum([box | boxes], twos, threes) do
    occurrences = box
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
        Map.put(acc, char, (acc[char] || 0) + 1)
      end)

    twos = if Enum.any?(occurrences, fn {_, v} -> v == 2 end) do twos + 1 else twos end
    threes = if Enum.any?(occurrences, fn {_, v} -> v == 3 end) do threes + 1 else threes end
    compute_checksum(boxes, twos, threes)
  end

  defp compute_checksum([], twos, threes) do
    twos * threes
  end
end

IO.puts "Checksum: #{Box.run}"
