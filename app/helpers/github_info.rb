require 'github_api'

class GithubInfo
	def self.client
		@client ||= new(
			user: ENV['GITHUB_USER'],
			password: ENV['GITHUB_PASS'],
			api_url: ENV['GITHUB_API_URL'],
			organization: 'Portland'
		)
	end

  def initialize(user:, password:, api_url:, organization:)
    Github.configure do |c|
      c.basic_auth = "#{user}:#{password}"
      c.endpoint = api_url
      c.org = organization
    end
    @organization = organization
    @github = Github.new
  end

  def prs_by_repo
    @prs_by_repo = repo_names.map do |repo_name|
      repo_pulls = @github.pulls.list(user: @organization, repo: repo_name)
      prs = repo_pulls.map do |rp|
        { user: rp.dig(:assignee, :login), title: rp.dig(:title) }
      end
      { repo: repo_name, prs: prs } unless prs.empty?
    end.compact
  end

	def code_reviews
    @code_reviews ||= github.issues.list(
      labels: 'Status: Needs Review',
      filter: 'all'
    ).map { |pull_request| pull_request.slice(:html_url, :title) }
  end

  def repos
    @repos = @github.repos.list
  end

  def repo_names
    repos.map { |r| r['name'] }
  end
end
