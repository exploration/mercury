defmodule Mercury.Email do
  import Bamboo.Email
  alias Mercury.Batch.State


  def email(state) do
    new_email(
      to: State.merge(state, :to),
      cc: State.merge(state, :cc),
      bcc: State.merge(state, :bcc),
      from: {State.merge(state, :from_name), State.merge(state, :from)},
      subject: State.merge(state, :subject),
      text_body: State.merge(state, :body)
    )
    |> Bamboo.MandrillHelper.template("basic-email", [%{"name" => "main", "content" => State.merge(state, :body)}])
  end
end

defimpl Jason.Encoder, for: Bamboo.Email do
  def encode(value, opts) do
    {from_name, from} = value.from
    gather = fn {_a, b}, acc -> acc <> (b || "") end
    to = Enum.reduce value.to, "", gather
    cc = Enum.reduce value.cc, "", gather
    bcc = Enum.reduce value.bcc, "", gather
    map =
      Map.take(value, [:headers, :html_body, :text_body])
      |> Map.merge(%{from_name: from_name, from: from, to: to, cc: cc, bcc: bcc})
    Jason.Encode.map(map, opts)
  end
end
