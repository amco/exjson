defprotocol JSON, [generate(element)]

defimpl JSON, for: Atom do
  def generate(atom), do: Binary.escape(atom_to_binary(atom), ?")
end

defimpl JSON, for: BitString do
  def generate(thing), do: Binary.escape(thing, ?")
end

defimpl JSON, for: Number do
  def generate(number), do: "#{number}"
end

defimpl JSON, for: Tuple do
  def generate({}), do: "{}"

  def generate({key, value}) do
    "#{JSON.generate(key)}:#{JSON.generate(value)}"
  end
end

defimpl JSON, for: List do
  def generate([]), do: "{}"
  def generate([{}]), do: "{}"

  def generate(list) do
    if Enum.any?(list, fn(x, do: is_tuple(x))) do
      "{#{Enum.join(Enum.map(list, JSON.generate(&1)),",")}}"
    else:
      "[#{Enum.join(Enum.map(list, JSON.generate(&1)),",")}]"
    end
  end
end
