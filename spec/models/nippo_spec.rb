# frozen_string_literal: true
RSpec.describe Nippo do
  subject { FG.build(:nippo) }

  it { is_expected.to be_valid }

  it { is_expected.to be_invalid_on(:reported_for).with(nil) }
  it { is_expected.to be_invalid_on(:reported_for).with('') }
  it { is_expected.to be_invalid_on(:reported_for).with('invalid date') }

  describe 'uniqueness validation' do
    let(:user) { FG.create(:user) }
    let(:reported_for) { Time.zone.today }
    subject { FG.build(:nippo, user: user) }

    context 'when written nippo owner is NOT current user' do
      before { FG.create(:nippo, reported_for: reported_for) }

      it { is_expected.to be_valid_on(:reported_for).with(reported_for) }
      it { is_expected.to be_valid_on(:reported_for).with(reported_for - 1) }
    end

    context 'when written nippo owner is same as current user' do
      before { FG.create(:nippo, reported_for: reported_for, user: user) }

      it { is_expected.to be_invalid_on(:reported_for).with(reported_for) }
      it { is_expected.to be_valid_on(:reported_for).with(reported_for - 1) }
    end
  end

  describe 'fix validation after sent' do
    subject { FG.create(:nippo, status: :sent) }

    it { is_expected.to be_invalid_on(:subject).with('changed') }
    it { is_expected.to be_invalid_on(:body).with('changed') }
  end

  describe '#dated_subject' do
    before do
      subject.subject = 'pre %s post'
      subject.reported_for = Date.parse('2016-06-04')
    end

    it 'returns subject string when date inserted' do
      expect(subject.dated_subject).to eq 'pre 2016/06/04 post'
    end
  end

  describe '.default_report_date' do
    let(:input_time) { Time.zone.parse(input) }
    let(:expected_date) { Date.parse(expected) }

    context 'Mon-Fri after 10AM' do
      where(:input, :expected) do
        [
          ['2016-06-06 10:00', '2016-06-06'],
          ['2016-06-07 10:00', '2016-06-07'],
          ['2016-06-08 10:00', '2016-06-08'],
          ['2016-06-09 10:00', '2016-06-09'],
          ['2016-06-10 10:00', '2016-06-10'],
        ]
      end

      with_them do
        it 'returns the same date' do
          expect(Nippo.default_report_date(input_time)).to eq expected_date
        end
      end
    end

    context 'Tue-Fri before 10AM' do
      where(:input, :expected) do
        [
          ['2016-06-07 09:59', '2016-06-06'],
          ['2016-06-08 09:59', '2016-06-07'],
          ['2016-06-09 09:59', '2016-06-08'],
          ['2016-06-10 09:59', '2016-06-09'],
        ]
      end

      with_them do
        it 'returns the day before' do
          expect(Nippo.default_report_date(input_time)).to eq expected_date
        end
      end
    end

    context 'before Mon 10AM' do
      where(:input, :expected) do
        [
          ['2016-06-11 09:59', '2016-06-10'],
          ['2016-06-11 10:00', '2016-06-10'],
          ['2016-06-12 09:59', '2016-06-10'],
          ['2016-06-12 10:00', '2016-06-10'],
          ['2016-06-13 09:59', '2016-06-10'],
        ]
      end

      with_them do
        it 'returns the day of last friday' do
          expect(Nippo.default_report_date(input_time)).to eq expected_date
        end
      end
    end
  end
end
