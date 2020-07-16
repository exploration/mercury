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
    |> Bamboo.MandrillHelper.template("basic-email", [%{"name" => "main", "content" => basic_html(State.merge(state, :body))}])
  end

  @doc "Basic conversion of text to HTML, if there are no paragraph tags"
  def basic_html(text) do
    if text =~ ~r/(<p|<div)/i do
      text
      |> filter_smart_quotes()
    else
      String.replace(text, "\n", "<br>")
      |> filter_smart_quotes()
    end
  end

  defp filter_smart_quotes(text) do
    text
    |> String.replace(~r/[\x{201C}\x{201D}\x{201E}\x{201F}\x{2033}\x{2036}]/u, "\"")
    |> String.replace(~r/[\x{2018}\x{2019}\x{201A}\x{201B}\x{2032}\x{2035}]/u, "'")
  end
end
