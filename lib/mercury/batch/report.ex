defmodule Mercury.Batch.Report do
  @derive {Jason.Encoder, only: [:from, :from_name, :to, :cc, :bcc, :subject, :text_body, :sent_at, :status]}

  defstruct [:bamboo_email, :from, :from_name, :to, :cc, :bcc, :subject, :text_body, :sent_at, :status]

  @doc """
  Given the results of Mailer.deliver(email) - a %Bamboo.Email{} and a status, construct a report
  """
  def new(%Bamboo.Email{} = email, status) do
    {from_name, from} = email.from

    %__MODULE__{
      bamboo_email: email, 
      from_name: from_name, 
      from: from, 
      to: gather(email.to), 
      cc: gather(email.cc), 
      bcc: gather(email.bcc),
      subject: email.subject,
      text_body: email.text_body,
      sent_at: NaiveDateTime.utc_now,
      status: inspect(status)
    }
  end

  defp gather(item, acc \\ "") do
    case item do
      [_] = items ->
        Enum.reduce items, "", &gather/2
      {_name, address} ->
        String.trim "#{acc} #{address}"
      address ->
        String.trim "#{acc} #{address}"
    end
  end
end
