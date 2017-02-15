class CodeReviewsController < ActionController::Base
  before_action :validate_slack_token

  def index
    formatted_code_reviews = GithubInfo.client.code_reviews.map do |code_review|
      "<#{code_review[:html_url]}|#{code_review[:title]}>"
    end.join("\n")

    render(
      json: {
        response_type: 'in_channel',
        text: 'Pull requests open for review',
        attachments: [
          text: formatted_code_reviews
        ]
      },
      status: 200
    )
  end

  private

  def validate_slack_token
    invalid_slack_token! unless params['token'] == ENV['SLACK_TOKEN']
  end

  def invalid_slack_token!
    render json: { errors: ['Slack token invalid']}
  end
end
