package Spork::Formatter::TKSlide;
use strict;
use Spoon::Formatter '-base';

const top_class => 'Spork::Formatter::TKSlide::Top';

sub formatter_classes {
    map { "Spork::Formatter::TKSlide::$_" } qw(
        Header Paragraph Preformatted
        Ulist1 Ulist2 Ulist3 Ulist4
        Olist1 Olist2 Olist3 Olist4
        Item1 Item2 Item3 Item4
        Bold Italic Underline Inline 
        HyperLink File Image
    );
}

################################################################################
package Spork::Formatter::TKSlide::Unit;
use base 'Spoon::Formatter::Unit';
field hide => 0;

sub parse_blocks {
    my $self = shift;
    my $text = $self->text;
    $self->text(undef);
    my $units = $self->units;
    my $table = $self->hub->formatter->table;
    my $contains = $self->contains_blocks;
    while ($text) {
        my($match,$hide);
	$text =~ s/^\s*\n//m;
	$hide = 1  if($text =~ s/^\+//s);
        for my $format_id (@$contains) {
            my $class = $table->{$format_id}
              or die "No class for $format_id";
            my $unit = $class->new;
            $unit->text($text);
            $unit->match or next;
            $match = $unit
              if not defined $match or 
                 $unit->start_offset < $match->start_offset;
            last unless $match->start_offset;
        }
        if (not defined $match) {
            push @$units, $text;
            last;
        }
	$match->hide($hide);
        $match->hub($self->hub);
        push @$units, substr($text, 0, $match->start_offset)
          if $match->start_offset;
        $text = substr($text, $match->end_offset);
        push @$units, $match;
    }
    $_->parse for grep ref($_), @{$self->units};
}

sub inner_to_html {
    my $self = shift;
    my $units = $self->units;
    for (my $i = 0; $i < @$units; $i ++) {
        $units->[$i] = $self->escape_html($units->[$i])
          unless ref $units->[$i];
    }
    my $inner = $self->text_filter(join '',
        map {
            ref($_) ? $_->to_html : $_;
        } @{$units}
    );
    return $inner;
}

sub to_html {
    my $self = shift;
    my $inner = $self->inner_to_html;
    if($self->hide) {$inner = qq{<div title="hide">$inner</div>}}
    return $self->html_start . $inner . $self->html_end;
}

################################################################################
package Spork::Formatter::TKSlide::Top;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'top';
const contains_blocks => [qw(header ul1 ol1 pre p)];

################################################################################
package Spork::Formatter::TKSlide::Header;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'header';
const contains_phrases => [qw(b i u tt)];
field 'level'; 

sub to_html {
    my $self = shift;
    my $text = join '', map {
        ref $_ ? $_->to_html : $_
    } @{$self->units};
    my $level = $self->level;
    $self->hub->slides->slide_heading($text)
      unless $self->hub->slides->slide_heading;
    if($self->hide) {
	return qq{<h$level title="hide">$text</h$level>\n};
    }
    return "<h$level>$text</h$level>\n";
}

sub match {
    my $self = shift;
    return unless $self->text =~ /^(={1,6}) (.*?)=*\s*\n+/m;
    $self->level(length($1));
    $self->set_match($2);
}

################################################################################
package Spork::Formatter::TKSlide::Paragraph;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'p';
const html_start => "<p>\n";
const html_end => "</p>\n";
const contains_phrases => [qw(b i u tt hyper file image)];

sub match {
    my $self = shift;
    return unless $self->text =~ /((?:^[^\+\=\#\*\0\s].*\n)+)/m;
    $self->set_match;
}

################################################################################
package Spork::Formatter::TKSlide::Ulist;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'ul';
const html_start => "<ul>\n";
const html_end => "</ul>\n";
const level => 1;

sub match {
    my $self = shift;
    my $level = $self->level;
    return unless
      $self->text =~ /((?:^\+?\*{$level} .*\n)(?:^\+?[*0 ]{$level,} .*\n)*)/m;
    $self->set_match;
}

################################################################################
for my $level (1..4) {
    my $list = join ' ', $level != 4 
    ? ("ul" . ($level + 1), "ol" . ($level + 1), "li$level")
    : ("li$level");
    eval <<END; die $@ if $@;
package Spork::Formatter::TKSlide::Ulist$level;
use base 'Spork::Formatter::TKSlide::Ulist';
const formatter_id => 'ul$level';
const level => $level;
const contains_blocks => [qw($list)];
END
}

################################################################################
package Spork::Formatter::TKSlide::Olist;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'ol';
field html_start => "<ol>\n";
field html_end => "</ol>\n";

sub match {
    my $self = shift;
    my $level = $self->level;
    return unless 
      $self->text =~ /((?:^0{$level} .*\n)(?:^[\*0 ]{$level,} .*\n)*)/m;
    $self->set_match;
}

################################################################################
for my $level (1..4) {
    my $list = join ' ', $level != 4 
    ? ("ol" . ($level + 1), "ul" . ($level + 1), "li$level")
    : ("li$level");
    eval <<END; die $@ if $@;
package Spork::Formatter::TKSlide::Olist$level;
use base 'Spork::Formatter::TKSlide::Olist';
const formatter_id => 'ol$level';
const level => $level;
const contains_blocks => [qw($list)];
END
}

################################################################################
package Spork::Formatter::TKSlide::Item;
use base 'Spork::Formatter::TKSlide::Unit';
const html_start => "<li>";
const html_end => "</li>\n";
const contains_phrases => [qw(hyper b i u tt hyper file image)];

sub match {
    my $self = shift;
    my $level = $self->level;
    return unless 
      $self->text =~ /^\+?[0\*]{$level} +(.*)\n/m;
    $self->set_match;
}

sub to_html {
    my $self = shift;
    my $inner = $self->inner_to_html;
    if($self->hide) {
	return q{<li title="hide">} . $inner . $self->html_end;
    }
    return $self->html_start . $inner . $self->html_end;
}


################################################################################
for my $level (1..4) {
    eval <<END; die $@ if $@;
package Spork::Formatter::TKSlide::Item$level;
use base 'Spork::Formatter::TKSlide::Item';
const formatter_id => 'li$level';
const level => $level;
END
}

################################################################################
package Spork::Formatter::TKSlide::Preformatted;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'pre';

sub match {
    my $self = shift;
    return unless $self->text =~ /((?:^ +\S.*?\n|^\n)+)/m;
    my ($text, $start, $end) = ($1, $-[0], $+[0]);
    return unless $text =~ /\S/;
    $self->set_match($text, $start, $end);
}

sub to_html {
    my $self = shift;
    my $formatted = join '', map {
        my $text = $_;
        $text =~ s/(?<=\n)\s*$//;
        my $indent;
        for ($text =~ /^( +)/gm) {
            $indent = length()
              if not defined $indent or
                 length() < $indent;
        }
        $text =~ s/^ {$indent}//gm;
        $self->escape_html($text);
    } @{$self->units};
    qq{<blockquote>\n<pre style="font-size:13">$formatted</pre>\n</blockquote>\n};
}

################################################################################
# Phrase Classes
################################################################################
package Spork::Formatter::TKSlide::Bold;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'b';
const html_start => "<b>";
const html_end => "</b>";
# field const contains_phrases => [qw(i u tt href mail wiki)];
const contains_phrases => [qw(i u tt)]; #XXX
const pattern_start => qr/(^|(?<=\s))\*(?=\S)/;
const pattern_end => qr/\*(?=\W|\z)/;

################################################################################
package Spork::Formatter::TKSlide::Italic;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'i';
const html_start => "<i>";
const html_end => "</i>";
const contains_phrases => [qw(b u tt)];
const pattern_start => qr/(^|(?<=\s))\/(?=\S)/;
const pattern_end => qr/\/(?=\W|\z)/;

################################################################################
package Spork::Formatter::TKSlide::Underline;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'u';
const html_start => "<u>";
const html_end => "</u>";
# field const contains_phrases => [qw(b u tt href mail wiki)];
const contains_phrases => [qw(b i tt)]; #XXX
const pattern_start => qr/(^|(?<=\s))_(?=\S)/;
const pattern_end => qr/_(?=\W|\z)/;

################################################################################
package Spork::Formatter::TKSlide::Inline;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'tt';
const html_start => qq{<tt style="font-size:13">};
const html_end => "</tt>";
const pattern_start => qr/(^|(?<=\s))\|(?=\S)/;
const pattern_end => qr/(?!<\\)\|(?=\W|\z)/;

################################################################################
package Spork::Formatter::TKSlide::HyperLink;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'hyper';
const pattern_start => qr/http:\/\/\S+/;

sub html_start {
    my $self = shift;
    '<a href="' . $self->matched . 
    '" target="external" style="text-decoration:underline">' . 
    $self->matched . '</a>';
}

################################################################################
package Spork::Formatter::TKSlide::File;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'file';
const pattern_start => qr/(^|(?<=\s))file</;
const pattern_end => qr/>/;
field 'link_file';
field 'link_text';

sub text_filter {
    my $self = shift;
    my $text = shift;
    $text =~ s/(.*?)(?:\s+|\z)//;
    $self->link_file($1);
    $self->link_text($text || $self->link_file);
    return '';
}

sub html_start {
    my $self = shift;
    require Cwd;
    my $file = $self->link_file;
    $file = $self->hub->config->file_base . "/$file"
      unless $file =~ /^\.{0,1}\//;
    $file = Cwd::abs_path($file);
    qq{<a href="file://$file" } . 
      'target="file" style="text-decoration:underline">' . 
      $self->link_text . '</a>';
}

################################################################################
package Spork::Formatter::TKSlide::Image;
use base 'Spork::Formatter::TKSlide::Unit';
const formatter_id => 'image';
const pattern_start => qr/(^|(?<=\s))image</;
const pattern_end => qr/>/;

sub to_html {
    my $self = shift;
    $self->hub->slides->image_url($self->units->[0]);
    return '';
}

1;
