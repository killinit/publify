require File.join(Rails.root, 'lib', 'popular_article')

describe PopularArticle do
  let!(:blog) { create(:blog) }

  subject { described_class }

  describe '#generate' do
    before(:each) do
      allow(GoogleAnalytics::API)
        .to receive(:fetch_article_page_views)
        .and_return(popular_articles)
    end

    let(:popular_articles) {
      [
        {
          page_views: 39,
          label: 'how-haggling-can-help-you-pay-less-for-a-second-hand-car',
          url: 'blog.moneyadviceservice.org.uk/en/blog/how-haggling-can-help-you-pay-less-for-a-second-hand-car'
        },
        {
          page_views: 24,
          label: 'foo-article',
          url: 'blog.moneyadviceservice.org.uk/en/blog/foo-article'
        },
        {
          page_views: 14,
          label: 'woo-article',
          url: 'blog.moneyadviceservice.org.uk/en/blog/woo-article'
        },
        {
          page_views: 10,
          label: 'bar-article',
          url: 'blog.moneyadviceservice.org.uk/en/blog/bar-article'
        }
      ]
    }

    let!(:found_articles) {
      create(:article, permalink: 'how-haggling-can-help-you-pay-less-for-a-second-hand-car', published_at: Time.utc(2004, 6, 1))
      create(:article, permalink: 'foo-article', published_at: Time.utc(2004, 6, 1))
      create(:article, permalink: 'woo-article', published_at: Time.utc(2004, 6, 1))
      create(:article, permalink: 'bar-article', published_at: Time.utc(2004, 6, 1))
    }

    it 'gets the most popular blog articles' do
      expect(GoogleAnalytics::API).to receive(:fetch_article_page_views).and_return(popular_articles)

      subject.generate
    end

    it 'generates the 3 most popular articles by default' do
      allow(GoogleAnalytics::API).to receive(:fetch_article_page_views).and_return(popular_articles)

      expect(subject.generate.size).to eql(3)
    end

    it 'looks up each article' do
      allow(GoogleAnalytics::API).to receive(:fetch_article_page_views).and_return(popular_articles)

      expect(subject.generate).not_to be_empty
    end
  end
end
