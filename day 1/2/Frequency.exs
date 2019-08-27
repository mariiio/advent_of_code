defmodule Frequency do
  def run(frequency, frequencies_mapset) do
    {:ok, frequencies} = File.read("frequencies.txt")
    frequencies |> String.split("\n", trim: true) |> compute_frequency(frequency, frequencies_mapset)
  end

  defp compute_frequency([new_frequency_string | frequencies], frequency, frequencies_mapset) do
    {new_frequency, _} = new_frequency_string
    |> String.slice(1, String.length(new_frequency_string))
    |> Integer.parse

    new_frequency = case String.first(new_frequency_string) do
      "+" -> frequency + new_frequency
      "-" -> frequency - new_frequency
    end

    # Unsafe new_frequency?
    if MapSet.member?(frequencies_mapset, new_frequency) do
      new_frequency
    else
      compute_frequency(frequencies, new_frequency, MapSet.put(frequencies_mapset, new_frequency))
    end

  end

  defp compute_frequency([], frequency, frequencies_mapset) do
    # Q: How to avoid reading the whole file again?
    # - Recursively pass around the unmodified list too?
    # - Have some sort of state?
    # - Stream cycle
    run(frequency, frequencies_mapset)
  end
end

IO.puts "Frequency: #{Frequency.run(0, MapSet.new())}"
