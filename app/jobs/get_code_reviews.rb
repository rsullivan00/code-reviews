class GetCodeReviews
  include SuckerPunch::Job

  def perform(response_url:)
    formatted_code_reviews = GithubInfo.client.code_reviews.map do |code_review|
      format_code_review(code_review)
    end

    uri = URI.parse(response_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(
      uri.request_uri,
      'Content-Type' => 'application/json'
    )
    request.body = {
      response_type: 'in_channel',
      text: 'Pull requests open for review',
      attachments: formatted_code_reviews
    }.to_json
    response = http.request(request)
  end

  private

  def format_code_review(code_review)
    {
      fallback: code_review[:html_url],
      title: "<#{code_review[:html_url]}|#{code_review[:title]}>",
      author_name: code_review[:user][:login],
      author_link: code_review[:user][:html_url],
      author_icon: code_review[:user][:avatar_url]
    }
  end
end
