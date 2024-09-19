#!/usr/bin/perl
use strict;
use warnings;

package RPM;
use vars qw(%hdr_tags);
%hdr_tags = (
  1023 => { 'TAGNAME' => 'PREIN', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1024 => { 'TAGNAME' => 'POSTIN', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1025 => { 'TAGNAME' => 'PREUN', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1026 => { 'TAGNAME' => 'POSTUN', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1085 => { 'TAGNAME' => 'PREINPROG', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1086 => { 'TAGNAME' => 'POSTINPROG', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1087 => { 'TAGNAME' => 'PREUNPROG', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
  1088 => { 'TAGNAME' => 'POSTUNPROG', 'GROUP' => 'TRIGGER', 'NAME' => '', 'TYPE' => 1 },
);
sub TIEHASH {
  my $RPM_HEADER_MAGIC = chr(0x8e).chr(0xad).chr(0xe8);
  my $RPM_FILE_MAGIC   = chr(0xed).chr(0xab).chr(0xee).chr(0xdb);
  my $buff;
  my ($class_name, $filename, $readtype) = @_;
  my $self = bless { hash => {}, }, $class_name;
  if (!defined($filename) or !open(RPMFILE, "<$filename")) { return undef; }
  binmode(RPMFILE); read(RPMFILE, $buff, 96);
  ( $self->{'hash'}->{'LEAD_MAGIC'}, $self->{'hash'}->{'LEAD_MAJOR'}, $self->{'hash'}->{'LEAD_MINOR'}, $self->{'hash'}->{'LEAD_TYPE'}, $self->{'hash'}->{'LEAD_ARCHNUM'}, $self->{'hash'}->{'LEAD_NAME'}, $self->{'hash'}->{'LEAD_OSNUM'}, $self->{'hash'}->{'LEAD_SIGNATURETYPE'}, $self->{'hash'}->{'LEAD_RESERVED'} ) = unpack("a4CCssA66ssA16", $buff);
  if (!$self->{'hash'}->{'LEAD_MAGIC'} eq $RPM_FILE_MAGIC) { return 0; }
  for (my $header_num=1; $header_num < 3; $header_num++) {
    read(RPMFILE, $buff, 16);
    my ($header_magic, $header_version, $header_reserved, $header_entries, $header_size) = unpack("a3CNNN", $buff);
    if ($header_magic eq $RPM_HEADER_MAGIC) {
      my $record;
      read(RPMFILE, $record, 16*$header_entries);
      if ($header_num == 1) {
        if (($header_size % 8) == 0) { read(RPMFILE, $buff, $header_size); }
        else { read(RPMFILE, $buff, $header_size+(8-($header_size % 8))); }
      } else { read(RPMFILE, $buff, $header_size); }
      for (my $record_num=0; $record_num < $header_entries; $record_num++) {
        my ($tag, $type, $offset, $count) = unpack("NNNN", substr($record, $record_num*16, 16));
        my @value;
        if ($header_num == 1) { $tag = $tag*10; }
        if (!defined($hdr_tags{$tag})) { next; }
        elsif ($type == 0) { @value = (''); }
        elsif ($type == 1) { print "$hdr_tags{$tag}{'TAGNAME'}\n"; }
        elsif ($type == 2) { @value = unpack("C*", substr($buff, $offset, 1*$count)); $offset = 1*$count; }
        elsif ($type == 3) { @value = unpack("n*", substr($buff, $offset, 2*$count)); $offset = 2*$count; }
        elsif ($type == 4) { @value = unpack("N*", substr($buff, $offset, 4*$count)); $offset = 4*$count; }
        elsif ($type == 5) { print "$hdr_tags{$tag}{'TAGNAME'}\n"; }
        if ($type == 6 or $type == 8 or $type == 9) {
          for(my $i=0;$i<$count;$i++) {
            my $length = index($buff, "\0", $offset)-$offset;
            push(@value, substr($buff, $offset, $length));
            $offset += $length+1;
          }
        }
        elsif ($type == 7) { $value[0] = substr($buff, $offset, $count); }
        if (defined($hdr_tags{$tag}{'TYPE'}) and $hdr_tags{$tag}{'TYPE'} == 1) {
          @{$self->{'hash'}->{$hdr_tags{$tag}{'TAGNAME'}}} = @value;
        } else { $self->{'hash'}->{$hdr_tags{$tag}{'TAGNAME'}} = $value[0]; }
      }
    }
  }
  return $self;
}
sub FETCH { my ($self, $key) = @_; return $self->{hash}->{$key}; }
1;

package main;
die "Usage: $0 <phase> <rpm-file>\n" until @ARGV == 2;
my ($phase, $file) = ($ARGV[0], $ARGV[1]);
my %phases = (preinst => "PREIN", postinst => "POSTIN", prerm => "PREUN", postrm => "POSTUN");
tie my %rpm, 'RPM', $file or die "Could not open RPM file: $!";
print @{$rpm{$phases{$phase}}};
