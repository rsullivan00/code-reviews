class CodeReviewsController < ActionController::Base
  before_action :validate_slack_token

  def index
    render json: GithubInfo.client.code_reviews.to_json
  end

  private

  def validate_slack_token
    invalid_slack_token! unless params['token'] == ENV['SLACK_TOKEN']
  end

  def invalid_slack_token!
    render json: { errors: ['Slack token invalid']}
  end
end
