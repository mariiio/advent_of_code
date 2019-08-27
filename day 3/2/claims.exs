defmodule Point do
  defstruct x: 0, y: 0
end

defmodule Fabric do
  defstruct id: 0, x: 0, y: 0, width: 0, height: 0

  def run do
    {:ok, claims_string} = File.read("claims.txt")
    claims = claims_string
    |> String.split("\n", trim: true)
    |> Enum.map(&(fabric_from_string(&1)))

    claims
    |> overlapping_square_inches(Map.new())
    |> no_overlapping_claim(claims)
  end

  defp fabric_from_string(fabric_string) do
    regex = ~r/#(?<id>[\d]+) @ (?<x>[\d]+),(?<y>[\d]+): (?<width>[\d]+)x(?<height>[\d]+)/
    fabric_map = Regex.named_captures(regex, fabric_string)

    # There's gotta be a better way..
    {id, _} =  Integer.parse(fabric_map["id"])
    {x, _} = Integer.parse(fabric_map["x"])
    {y, _} = Integer.parse(fabric_map["y"])
    {width, _} = Integer.parse(fabric_map["width"])
    {height, _} = Integer.parse(fabric_map["height"])

    %Fabric{
      id: id,
      x: x,
      y: y,
      width: width,
      height: height
    }
  end

  defp overlapping_square_inches([claim | claims], points) do
    x_range = Enum.to_list(claim.x..claim.x+claim.width-1)
    y_range = Enum.to_list(claim.y..claim.y+claim.height-1)

    new_points = compute_range(points, x_range, y_range)
    overlapping_square_inches(claims, new_points)
  end

  defp overlapping_square_inches([], points) do
    points
  end

  defp compute_range(points, x_range, y_range) do
    (for x <- x_range, y <- y_range, do: %Point{x: x, y: y})
    |> Enum.into(points, fn point ->
      {point, (Map.get(points, point) || 0) + 1}
    end)
  end

  def no_overlapping_claim(points, claims) do
    no_overlapping_claim = Enum.find(claims, fn claim ->
      x_range = Enum.to_list(claim.x..claim.x+claim.width-1)
      y_range = Enum.to_list(claim.y..claim.y+claim.height-1)
      (for x <- x_range, y <- y_range, do: %Point{x: x, y: y})
      |> Enum.all?(&(points[&1] == 1))
    end)

    no_overlapping_claim.id
  end

end

IO.puts "No overlapping claim id: #{Fabric.run}"
