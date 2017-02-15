class CodeReviewsController < ActionController::Base
  before_action :validate_slack_token

  def index
    formatted_code_reviews = GithubInfo.client.code_reviews.map do |code_review|
      format_code_review(code_review)
    end

    render(
      json: {
        response_type: 'in_channel',
        text: 'Pull requests open for review',
        attachments: formatted_code_reviews
      },
      status: 200
    )
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

  def validate_slack_token
    invalid_slack_token! unless params['token'] == ENV['SLACK_TOKEN']
  end

  def invalid_slack_token!
    render json: { errors: ['Slack token invalid']}
  end
end
