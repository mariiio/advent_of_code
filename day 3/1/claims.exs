defmodule Point do
  defstruct x: 0, y: 0
end

defmodule Fabric do
  defstruct id: 0, x: 0, y: 0, width: 0, height: 0

  def run do
    {:ok, claims} = File.read("claims.txt")
    claims
    |> String.split("\n", trim: true)
    |> Enum.map(&(fabric_from_string(&1)))
    |> overlapping_square_inches(Map.new())
  end

  defp fabric_from_string(fabric_string) do
    fabric_map =
    ~r/#(?<id>[\d]+) @ (?<x>[\d]+),(?<y>[\d]+): (?<width>[\d]+)x(?<height>[\d]+)/
    |> Regex.named_captures(fabric_string)
    |> Map.new(fn {k, v} ->
      {parsed_value, _} = Integer.parse(v)
      {String.to_atom(k), parsed_value}
    end)

    struct(Fabric, fabric_map)
  end

  defp overlapping_square_inches([claim | claims], points) do
    x_range = Enum.to_list(claim.x..claim.x+claim.width-1)
    y_range = Enum.to_list(claim.y..claim.y+claim.height-1)

    new_points = compute_range(points, x_range, y_range)
    overlapping_square_inches(claims, new_points)
  end

  defp overlapping_square_inches([], points) do
    Enum.count(points, fn {_, count} -> count > 1 end)
  end

  defp compute_range(points, x_range, y_range) do
    (for x <- x_range, y <- y_range, do: %Point{x: x, y: y})
    |> Enum.into(points, fn point ->
      {point, (Map.get(points, point) || 0) + 1}
    end)
  end
end

IO.puts "Overlapping square inches: #{Fabric.run}"
