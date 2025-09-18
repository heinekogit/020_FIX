use strict;
use warnings;

# ファイルを読み込む
my $csv_file = "03_materials/$koumoku_content[4]/front_end/mokuji.csv";
my $template_file = "toc_ncx_navPoint.txt";
my $ncx_file = "toc.ncx";
my $output_file = "output/toc.ncx";

open(my $fh_csv, "<:encoding(UTF-8)", $csv_file) or die "can't open $csv_file: $!";
open(my $fh_template, "<:encoding(UTF-8)", $template_file) or die "can't open $template_file: $!";
open(my $fh_ncx, "<:encoding(UTF-8)", $ncx_file) or die "can't open $ncx_file: $!";

my @mokuji_list = <$fh_csv>;
close($fh_csv);

my $template = do { local $/; <$fh_template> };
close($fh_template);

my @ncx_content = <$fh_ncx>;
close($fh_ncx);

# 目次の各行を処理してテンプレートに挿入
my $playOrder = 1;
my @navPoints;
foreach my $line (@mokuji_list) {
    chomp($line);
    my ($title, $page) = split(/,/, $line);
    my $id = sprintf("xhtml-p-%03d", $page);
    my $navPoint = $template;
    $navPoint =~ s/●navPoint_id●/$id/g;
    $navPoint =~ s/▼playOrder順番▼/$playOrder/g;
    $navPoint =~ s/●目次項目●/$title/g;
    $navPoint =~ s/●xhtmlファイル名●/$id.xhtml/g;
    push @navPoints, $navPoint;
    $playOrder++;
}

# ncxファイルの内容に目次を埋め込む
my $navPoints_text = join("\n", @navPoints);
foreach my $line (@ncx_content) {
    $line =~ s/▼navPointタグ印字位置▼/$navPoints_text/eg;
}

# 処理された内容を出力ファイルに書き出し
open(my $fh_output, ">:encoding(UTF-8)", $output_file) or die "can't open $output_file: $!";
print $fh_output @ncx_content;
close($fh_output);
