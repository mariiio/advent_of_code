defmodule Frequency do
  def run do
    {:ok, frequencies} = File.read("frequencies.txt")
    frequencies |> String.split("\n", trim: true) |> compute_frequency(0)
  end

  defp compute_frequency([head | tail], frequency) do
    {new_frequency, _} = head
    |> String.slice(1, String.length(head))
    |> Integer.parse

    case String.first(head) do
      "+" -> compute_frequency(tail, frequency + new_frequency)
      "-" -> compute_frequency(tail, frequency - new_frequency)
    end
  end

  defp compute_frequency([], frequency) do
    frequency
  end
end

IO.puts "Frequency: #{Frequency.run}"
