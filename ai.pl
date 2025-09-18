uuse strict;
use warnings;

# 画像の数
my $image_count = 10;
# 読み方向 (ltr または rtl)
my $reading_direction = 'ltr'; # or 'rtl'

# 基本のタグテンプレート
my $template = '<itemref linear="yes" idref="p-%03d" properties="page-spread-%s"/>';

# 初期のプロパティを決定
my $left_property = 'left';
my $right_property = 'right';

# 読み方向がrtlの場合、プロパティを反転
if ($reading_direction eq 'rtl') {
    ($left_property, $right_property) = ($right_property, $left_property);
}

# 配列にタグを格納する
my @itemref_tags;

# 画像の数だけタグを生成して配列に追加
for my $i (1..$image_count) {
    my $property = $i % 2 == 1 ? $left_property : $right_property;
    push @itemref_tags, sprintf $template, $i, $property;
}

# 配列の内容を出力 (デバッグ用)
print "$_\n" for @itemref_tags;

# 必要に応じて配列を返すこともできます
# return \@itemref_tags;
