defmodule Mercury.Email do
  import Bamboo.Email
  alias Mercury.Batch.State

  def email(state) do
    new_email(
      to: State.merge(state, :to),
      cc: State.merge(state, :cc),
      from: State.merge(state, :from),
      subject: State.merge(state, :subject),
      text_body: State.merge(state, :body)
    )
    |> Bamboo.MandrillHelper.template("basic-email", [%{"name" => "main", "content" => State.merge(state, :body)}])
  end
end
