class CodeReviewsController < ActionController::Base
  before_action :validate_slack_token

  def index
    GetCodeReviews.perform_async(response_url: params[:response_url])

    render(
      json: {
        response_type: 'ephemeral',
        text: 'Getting code reviews...'
      },
      status: 200
    )
  end

  def actions
  end

  private

  def validate_slack_token
    invalid_slack_token! unless params['token'] == ENV['SLACK_TOKEN']
  end

  def invalid_slack_token!
    render json: { errors: ['Slack token invalid']}
  end
end
