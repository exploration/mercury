defmodule Mercury.Email do
  import Bamboo.Email
  alias Mercury.Batch.State

  @doc """
  There is only one email - this email. The email to rule them all. You pass it Batch.State and it spits out the currently-selected email based on table data.
  """
  def email(%State{} = state) do
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
