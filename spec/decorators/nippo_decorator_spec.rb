# frozen_string_literal: true
RSpec.describe NippoDecorator, type: :decorator do
  subject { ActiveDecorator::Decorator.instance.decorate(FG.build(:nippo)) }

  describe '#needs_date_notice?' do
    context 'when nippo is persisted' do
      before { subject.save }

      where(:now) do
        (1..7).flat_map do |d|
          [
            [Time.zone.local(2016, 7, d, 10)],
            [Time.zone.local(2016, 7, d, 18)],
          ]
        end
      end

      with_them do
        it 'returns false' do
          travel_to(now) do
            expect(subject.send(:needs_date_notice?)).to eq false
          end
        end
      end
    end

    context 'when it\'s Satureday or Sunday' do
      where(:now) do
        [
          [Time.zone.local(2016, 7, 2, 10)],
          [Time.zone.local(2016, 7, 2, 18)],
          [Time.zone.local(2016, 7, 3, 10)],
          [Time.zone.local(2016, 7, 3, 18)],
        ]
      end

      with_them do
        it 'returns true' do
          travel_to(now) do
            expect(subject.send(:needs_date_notice?)).to eq true
          end
        end
      end
    end

    context 'when it\'s weekday' do
      where(:now, :expected) do
        (4..8).flat_map do |d|
          (0..13).map { |h| [Time.zone.local(2016, 7, d, h), true] } +
            (14..23).map { |h| [Time.zone.local(2016, 7, d, h), false] }
        end
      end

      with_them do
        it 'returns expected result' do
          travel_to(now) do
            expect(subject.send(:needs_date_notice?)).to eq expected
          end
        end
      end
    end

    context 'when nippo does NOT have `reported_for`' do
      before { subject.reported_for = nil }

      it 'returns false' do
        travel_to(Time.zone.local(2016, 7, 2, 10)) do
          expect(subject.send(:needs_date_notice?)).to eq false
        end
      end
    end
  end

  describe '#date_notice' do
    before { subject.extend(ActionView::Helpers) }

    context 'when #needs_date_notice? == false' do
      before { subject.save }

      it 'returns nil' do
        expect(subject.date_notice).to be_nil
      end
    end

    context 'when default reported_for is today' do
      before { subject.reported_for = Date.new(2016, 7, 1) }
      it 'returns tag' do
        travel_to(Time.zone.local(2016, 7, 1, 10)) do
          expect(subject.date_notice).to eq '<p class="date-notice">← 今日の日付です</p>'
        end
      end
    end

    context 'when default reported_for is yesterday' do
      before { subject.reported_for = Date.new(2016, 7, 4) }
      it 'returns tag' do
        travel_to(Time.zone.local(2016, 7, 5, 10)) do
          expect(subject.date_notice).to eq '<p class="date-notice">← 昨日の日付です</p>'
        end
      end
    end

    context 'when default reported_for is last friday' do
      before { subject.reported_for = Date.new(2016, 7, 1) }
      it 'returns tag' do
        travel_to(Time.zone.local(2016, 7, 4, 10)) do
          expect(subject.date_notice).to eq '<p class="date-notice">← 金曜日の日付です</p>'
        end
      end
    end

    context 'when nippo does NOT have `reported_for`' do
      before { subject.reported_for = nil }

      it 'returns nil' do
        expect(subject.date_notice).to be_nil
      end
    end
  end
end
