package Spork::Slides::TKSlide;
use strict;
use Spork::Slides '-base';
use IO::All;

our $VERSION = '0.01';

field const class_id => 'slides_tkslide';

sub make_slides {
    my $self = shift;
    $self->use_class('formatter');
    $self->use_class('template');

    $self->assert_directory($self->config->slides_directory);
    my @slides = $self->split_slides($self->config->slides_file);

    my $allpage_html;
    for (my $i = 0; $i < @slides; $i++) {
        my $slide = $slides[$i];
        $self->config->add_config($slide->{config});
        my $content = $slides[$i]{slide_content};
        $self->slide_heading('');
        $self->image_url('');
        my $parsed = $self->formatter->text_to_parsed($content);
        my $html = $parsed->to_html;
        $slide->{slide_heading} = $self->slide_heading;
        $slide->{image_html} = $self->get_image_html;
        my $output = $self->template->process('slide.html',
            %$slide,
            slide_content => $html,
            spork_version => "Spork v$Spork::VERSION",
        );
	$allpage_html .= $output;
    }
    my $output = $self->template
	->process('start.html',
		  style_file => $self->config->style_file,
		  allpage_content => $allpage_html,
		  spork_version => "Spork v$Spork::VERSION",
		 );
    my $file_name = $self->config->slides_directory . '/start.html';
    $output > io($file_name);
    $self->make_style;
    $self->make_javascript;
}

sub make_style {
    my $self = shift;
    $self->make_file($self->config->style_file);
}

sub make_javascript {
    my $self = shift;
    $self->make_file('controls.js');
}

sub make_file {
    my ($self,$template,$file) = @_;
    $file ||= $template;
    my $output = $self->template
	->process($template,
		  spork_version => "Spork v$Spork::VERSION",
		 );
    my $file_name = $self->config->slides_directory . "/$file";
    $output > io($file_name);
}

sub start_name {
    my $self = shift;
    $self->config->slides_directory . '/start.html';
}

sub split_slides {
    my $self = shift;
    my $slides_file = shift;
    my @slide_info;
    my @slides = grep $_, split /^-{4,}\s*\n/m, io($slides_file)->slurp;
    my $slide_num = 1;
    my $config = {};
    for my $slide (@slides) {
        if ($slide =~ /\A(^(---|\w+\s*:.*|-\s+.*|#.*)\n)+\z/m) {
            $config = $self->hub->config->parse_yaml($slide);
            next;
        }

	my $slide_info =
	    {
	     slide_num => $slide_num,
	     slide_content => $slide,
	     slide_name => "page$slide_num",
	     config => $config,
	    };
	$config = {};
	push @slide_info, $slide_info;
        $slide_num++;
    }
    return @slide_info;
}

sub sub_slides {
    my $self = shift;
    my $raw_slide = shift;
    my (@slides, $slide);
    for (split /^\+/m, $raw_slide) {
        push @slides, $slide .= $_;
    }
    return @slides;
}

sub get_image_html {
    my $self = shift;
    my $image_url = $self->image_url
      or return '';
    my $image_width;
    ($image_url, $image_width) = split /\s+/, $image_url;
    $image_width ||= $self->config->image_width;
    my $image_file = $image_url;
    $image_file =~ s/.*\///;
    my $images_directory = $self->config->slides_directory . '/images';
    $self->assert_directory($images_directory);
    my $image_html =
      qq{<img width="$image_width" src="images/$image_file" align="right">};
    return $image_html if -f "$images_directory/$image_file";
    require Cwd;
    my $home = Cwd::cwd();
    chdir($images_directory) or die;
    my $method = $self->config->download_method . '_download';
    warn "- Downloading $image_url\n";
    $self->$method($image_url, $image_file);
    chdir($home) or die;
    return -f "$images_directory/$image_file" ? $image_html : '';
}


=head1 NAME

Spork::Slides::TKSlide - Spork:TKSlide slides generation

=head1 DESCRIPTIONS

Read the source.

=head1 SEE ALSO

L<Spork>, L<Spork::Config::TKSlide>

=head1 COPYRIGHT

Copyright 2004 by Kang-min Liu <gugod@gugod.org>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

B<TKSlide> is done by Tkirby Wu <b88039@csie.ntu.edu.tw>,
the official site is at <http://www.csie.ntu.edu.tw/~b88039/slide/>.

=cut


1;
__DATA__
__Spork.slides__
----
presentation_topic: Spork:TKSlide
presentation_title: Spork:TKSlide Generate TKSlide with Spork.
presentation_place: NO
presentation_date: NO
----
image<http://gugod.org/imgs/spork/SporkCollection.jpg>
== What is Spork?
* Spork Stands for:
+** Slide Presentation (Only Really Kwiki)
+* Spork is a CPAN Module
+* Spork is Based on Spoon
+* Spork is an HTML Slideshow Generator
+** All slides are in one simple file
+** Run |spork -make| to make the slides
----
image<http://gugod.org/imgs/kirby/kirby.jpg>
== What is TKSlide?
* TKSlide stands for:
+** Tkirby's slides
+* Pure JavaScript navigation
+* XML / HTML backend
+* Cross Browser
+* http://www.csie.ntu.edu.tw/~b88039/slide/
----
== Spork::TKSlide
* Use Spork/Kwiki syntax
+** Thats easy
+* Generate the tkslide effect
+** That's cool.
+* So, That's *POWERFUL*
image<http://gugod.org/imgs/powerful/upside-down.jpg>
+* Check the source code of this slide:
** http://gugod.org/Slides/Spork-TKSlide/Spork.slides
----
= TEST SLIDE
image<http://gugod.org/imgs/spork/SporkCollection.jpg>
+
This slide is used to see how can "hide" element work. So everything
inside doesn't mean much.
+* Test
+** Test again
+** Cool ?
+* Not
+* Maybe drop the image to scary people
image<http://gugod.org/imgs/kirby/kirby.jpg>
----
== That's All

image<http://gugod.org/imgs/thank-you/thank-you.gif>

* The END
