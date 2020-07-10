class CodeReviewsController < ActionController::Base
  def index
    validate_slack_token(params['token'])
    GetCodeReviews.perform_async(response_url: params[:response_url])

    render(
      json: { response_type: 'ephemeral', text: 'Getting code reviews...' },
      status: 200
    )
  end

  def actions
    payload = JSON.parse(params['payload'])
    validate_slack_token(payload['token'])

    original_message = payload['original_message']
    user = payload['user']['name']
    original_message['attachments'] =
      original_message['attachments'].map do |attachment|
        if attachment['callback_id'] == payload['callback_id'] &&
             !(attachment['text'] && attachment['text'].include?(user))
          attachment['text'] = "#{attachment['text']}#{user} "
        end
        attachment
      end

    render(json: original_message.to_json, status: 200)
  end

  private

  def validate_slack_token(token)
    invalid_slack_token! unless token == ENV['SLACK_TOKEN']
  end

  def invalid_slack_token!
    render(
      json: {
        response_type: 'ephemeral',
        text: 'The Slack token sent to the server is invalid'
      }
    )
  end
end
