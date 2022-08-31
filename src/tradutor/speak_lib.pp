
unit speak_lib;
interface

{
  Automatically converted by H2Pas 1.0.0 from speak_lib.h
  The following command line parameters were used:
    -D
    -l
    espeak.dll
    speak_lib.h
}

  const
    External_library='espeak.dll'; {Setup as you need}

  Type
  Pdword  = ^dword;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


{$ifndef SPEAK_LIB_H}
{$define SPEAK_LIB_H}
  {**************************************************************************
   *   Copyright (C) 2005 to 2012 by Jonathan Duddington                     *
   *   email: jonsd@users.sourceforge.net                                    *
   *                                                                         *
   *   This program is free software; you can redistribute it and/or modify  *
   *   it under the terms of the GNU General Public License as published by  *
   *   the Free Software Foundation; either version 3 of the License, or     *
   *   (at your option) any later version.                                   *
   *                                                                         *
   *   This program is distributed in the hope that it will be useful,       *
   *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
   *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
   *   GNU General Public License for more details.                          *
   *                                                                         *
   *   You should have received a copy of the GNU General Public License     *
   *   along with this program; if not, see:                                 *
   *               <http://www.gnu.org/licenses/>.                           *
   ************************************************************************** }
  {*********************************************************** }
  { This is the header file for the library version of espeak  }
  {                                                            }
  {*********************************************************** }

  const
   ESPEAK_API_REVISION = 12;
  {
  Revision 2
     Added parameter "options" to eSpeakInitialize()

  Revision 3
     Added espeakWORDGAP to  espeak_PARAMETER

  Revision 4
     Added flags parameter to espeak_CompileDictionary()

  Revision 5
     Added espeakCHARS_16BIT

  Revision 6
    Added macros: espeakRATE_MINIMUM, espeakRATE_MAXIMUM, espeakRATE_NORMAL

  Revision 7  24.Dec.2011
    Changed espeak_EVENT structure to add id.string[] for phoneme mnemonics.
    Added espeakINITIALIZE_PHONEME_IPA option for espeak_Initialize() to report phonemes as IPA names.

  Revision 8  26.Apr.2013
    Added function espeak_TextToPhonemes().

  Revision 9  30.May.2013
    Changed function espeak_TextToPhonemes().

  Revision 10 29.Aug.2014
    Changed phonememode parameter to espeak_TextToPhonemes() and espeak_SetPhonemeTrace

  Revision 11 (espeak-ng)
    Made  import/export symbols correctly on Windows.

  Revision 12 (espeak-ng)
    Exposed espeak_SetPhonemeCallback. This is available in eSpeak, but was not exposed in this header.

   }
  {****************** }
  {  Initialization   }
  {****************** }
  { values for 'value' in espeak_SetParameter(espeakRATE, value, 0), nominally in words-per-minute }
    espeakRATE_MINIMUM = 80;
    espeakRATE_MAXIMUM = 450;
    espeakRATE_NORMAL = 175;
  { Retrieval mode: terminates the event list. }
  { Start of word }
  { Start of sentence }
  { Mark }
  { Audio element }
  { End of sentence or clause }
  { End of message }
  { Phoneme, if enabled in espeak_Initialize() }
  { internal use, set sample rate }

  type
    espeak_EVENT_TYPE = (espeakEVENT_LIST_TERMINATED = 0,espeakEVENT_WORD = 1,
      espeakEVENT_SENTENCE = 2,espeakEVENT_MARK = 3,
      espeakEVENT_PLAY = 4,espeakEVENT_END = 5,
      espeakEVENT_MSG_TERMINATED = 6,espeakEVENT_PHONEME = 7,
      espeakEVENT_SAMPLERATE = 8);
  { message identifier (or 0 for key or character) }
  { the number of characters from the start of the text }
  { word length, in characters (for espeakEVENT_WORD) }
  { the time in mS within the generated speech output data }
  { sample id (internal use) }
  { pointer supplied by the calling program }
  { used for WORD and SENTENCE events. }
(* Const before type ignored *)
  { used for MARK and PLAY events.  UTF8 string }
  { used for phoneme names (UTF8). Terminated by a zero byte unless the name needs the full 8 bytes. }

    espeak_EVENT = record
        _type : espeak_EVENT_TYPE;
        unique_identifier : dword;
        text_position : longint;
        length : longint;
        audio_position : longint;
        sample : longint;
        user_data : pointer;
        id : record
            case longint of
              0 : ( number : longint );
              1 : ( name : pChar );
              2 : ( _string : array[0..7] of char );
            end;
      end;
  {
     When a message is supplied to espeak_synth, the request is buffered and espeak_synth returns. When the message is really processed, the callback function will be repetedly called.


     In RETRIEVAL mode, the callback function supplies to the calling program the audio data and an event list terminated by 0 (LIST_TERMINATED).

     In PLAYBACK mode, the callback function is called as soon as an event happens.

     For example suppose that the following message is supplied to espeak_Synth:
     "hello, hello."
  
  
     * Once processed in RETRIEVAL mode, it could lead to 3 calls of the callback function :
  
     ** Block 1:
     <audio data> +
     List of events: SENTENCE + WORD + LIST_TERMINATED
  
     ** Block 2:
     <audio data> +
     List of events: WORD + END + LIST_TERMINATED
  
     ** Block 3:
     no audio data
     List of events: MSG_TERMINATED + LIST_TERMINATED
  
  
     * Once processed in PLAYBACK mode, it could lead to 5 calls of the callback function:
  
     ** SENTENCE
     ** WORD (call when the sounds are actually played)
     ** WORD
     ** END (call when the end of sentence is actually played.)
     ** MSG_TERMINATED
  
  
     The MSG_TERMINATED event is the last event. It can inform the calling program to clear the user data related to the message.
     So if the synthesis must be stopped, the callback function is called for each pending message with the MSG_TERMINATED event.
  
     A MARK event indicates a <mark> element in the text.
     A PLAY event indicates an <audio> element in the text, for which the calling program should play the named sound file.
   }

    espeak_POSITION_TYPE = (POS_CHARACTER = 1,POS_WORD,POS_SENTENCE
      );
  { PLAYBACK mode: plays the audio data, supplies events to the calling program }
  { RETRIEVAL mode: supplies audio data and events to the calling program  }
  { SYNCHRONOUS mode: as RETRIEVAL but doesn't return until synthesis is completed  }
  { Synchronous playback  }

    espeak_AUDIO_OUTPUT = (AUDIO_OUTPUT_PLAYBACK,AUDIO_OUTPUT_RETRIEVAL,
      AUDIO_OUTPUT_SYNCHRONOUS,AUDIO_OUTPUT_SYNCH_PLAYBACK
      );

    espeak_ERROR = (EE_INTERNAL_ERROR=-1, EE_OK = 0, EE_BUFFER_FULL = 1,
      EE_NOT_FOUND = 2);

  const
    espeakINITIALIZE_PHONEME_EVENTS = $0001;    
    espeakINITIALIZE_PHONEME_IPA = $0002;    
    espeakINITIALIZE_DONT_EXIT = $8000;    
(* Const before type ignored *)

  function espeak_Initialize(output:espeak_AUDIO_OUTPUT; buflength:longint; path:Pchar; options:longint):longint;cdecl;external External_library name 'espeak_Initialize';

  { Must be called before any synthesis functions are called.
     output: the audio data can either be played by eSpeak or passed back by the SynthCallback function.

     buflength:  The length in mS of sound buffers passed to the SynthCallback function.
              Value=0 gives a default of 60mS.
              This parameter is only used for AUDIO_OUTPUT_RETRIEVAL and AUDIO_OUTPUT_SYNCHRONOUS modes.
  
     path: The directory which contains the espeak-ng-data directory, or NULL for the default location.
  
     options: bit 0:  1=allow espeakEVENT_PHONEME events.
              bit 1:  1= espeakEVENT_PHONEME events give IPA phoneme names, not eSpeak phoneme names
              bit 15: 1=don't exit if espeak_data is not found (used for --help)
  
     Returns: sample rate in Hz, or -1 (EE_INTERNAL_ERROR).
   }

  procedure espeak_SetSynthCallback(SynthCallback:pointer);cdecl;external External_library name 'espeak_SetSynthCallback';

  { Must be called before any synthesis functions are called.
     This specifies a function in the calling program which is called when a buffer of
     speech sound data has been produced.


     The callback function is of the form:

  int SynthCallback(short *wav, int numsamples, espeak_EVENT *events);

     wav:  is the speech sound data which has been produced.
        NULL indicates that the synthesis has been completed.

     numsamples: is the number of entries in wav.  This number may vary, may be less than
        the value implied by the buflength parameter given in espeak_Initialize, and may
        sometimes be zero (which does NOT indicate end of synthesis).

     events: an array of espeak_EVENT items which indicate word and sentence events, and
        also the occurrence if <mark> and <audio> elements within the text.  The list of
        events is terminated by an event of type = 0.


     Callback returns: 0=continue synthesis,  1=abort synthesis.
   }
(* Const before type ignored *)
(* Const before type ignored *)
type 
    t_espeak_uriCallback = function (_para1:longint; _para2:Pchar; _para3:Pchar):longint; cdecl;
    pt_espeak_uriCallback = ^t_espeak_uriCallback;

  procedure espeak_SetUriCallback(UriCallback: pt_espeak_uriCallback);cdecl;external External_library name 'espeak_SetUriCallback';

  { This function may be called before synthesis functions are used, in order to deal with
     <audio> tags.  It specifies a callback function which is called when an <audio> element is
     encountered and allows the calling program to indicate whether the sound file which
     is specified in the <audio> element is available and is to be played.
  
     The callback function is of the form:
  
  int UriCallback(int type, const char *uri, const char *base);
  
     type:  type of callback event.  Currently only 1= <audio> element
  
     uri:   the "src" attribute from the <audio> element
  
     base:  the "xml:base" attribute (if any) from the <speak> element
  
     Return: 1=don't play the sound, but speak the text alternative.
             0=place a PLAY event in the event list at the point where the <audio> element
               occurs.  The calling program can then play the sound at that point.
   }
(* Const before type ignored *)
type
    t_espeak_phonemeCallback = function (_para1:Pchar):longint; cdecl;
    pt_espeak_phonemeCallback = ^t_espeak_phonemeCallback;

  procedure espeak_SetPhonemeCallback(PhonemeCallback:
t_espeak_phonemeCallback);cdecl;external External_library name 'espeak_SetPhonemeCallback';

  {****************** }
  {    Synthesis      }
  {****************** }
  const
    espeakCHARS_AUTO = 0;    
    espeakCHARS_UTF8 = 1;    
    espeakCHARS_8BIT = 2;    
    espeakCHARS_WCHAR = 3;    
    espeakCHARS_16BIT = 4;    
    espeakSSML = $10;    
    espeakPHONEMES = $100;    
    espeakENDPAUSE = $1000;    
    espeakKEEP_NAMEDATA = $2000;    
(* Const before type ignored *)

  function espeak_Synth(text:pointer; size:size_t; position:dword; position_type:espeak_POSITION_TYPE; end_position:dword; 
             flags:dword; unique_identifier:Pdword; user_data:pointer):espeak_ERROR;cdecl;external External_library name 'espeak_Synth';

  { Synthesize speech for the specified text.  The speech sound data is passed to the calling
     program in buffers by means of the callback function specified by espeak_SetSynthCallback(). The command is asynchronous: it is internally buffered and returns as soon as possible. If espeak_Initialize was previously called with AUDIO_OUTPUT_PLAYBACK as argument, the sound data are played by eSpeak.

     text: The text to be spoken, terminated by a zero character. It may be either 8-bit characters,
        wide characters (wchar_t), or UTF8 encoding.  Which of these is determined by the "flags"
        parameter.

     size: Equal to (or greatrer than) the size of the text data, in bytes.  This is used in order
        to allocate internal storage space for the text.  This value is not used for
        AUDIO_OUTPUT_SYNCHRONOUS mode.
  
     position:  The position in the text where speaking starts. Zero indicates speak from the
        start of the text.
  
     position_type:  Determines whether "position" is a number of characters, words, or sentences.
        Values:
  
     end_position:  If set, this gives a character position at which speaking will stop.  A value
        of zero indicates no end position.
  
     flags:  These may be OR'd together:
        Type of character codes, one of:
           espeakCHARS_UTF8     UTF8 encoding
           espeakCHARS_8BIT     The 8 bit ISO-8859 character set for the particular language.
           espeakCHARS_AUTO     8 bit or UTF8  (this is the default)
           espeakCHARS_WCHAR    Wide characters (wchar_t)
           espeakCHARS_16BIT    16 bit characters.
  
        espeakSSML   Elements within < > are treated as SSML elements, or if not recognised are ignored.
  
        espeakPHONEMES  Text within [[ ]] is treated as phonemes codes (in espeak's Kirshenbaum encoding).
  
        espeakENDPAUSE  If set then a sentence pause is added at the end of the text.  If not set then
           this pause is suppressed.
  
     unique_identifier: This must be either NULL, or point to an integer variable to
         which eSpeak writes a message identifier number.
         eSpeak includes this number in espeak_EVENT messages which are the result of
         this call of espeak_Synth().
  
     user_data: a pointer (or NULL) which will be passed to the callback function in
         espeak_EVENT messages.
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
(* Const before type ignored *)
(* Const before type ignored *)
  function espeak_Synth_Mark(text:pointer; size:size_t; index_mark:Pchar; end_position:dword; flags:dword; 
             unique_identifier:Pdword; user_data:pointer):espeak_ERROR;cdecl;external External_library name 'espeak_Synth_Mark';

  { Synthesize speech for the specified text.  Similar to espeak_Synth() but the start position is
     specified by the name of a <mark> element in the text.
  
     index_mark:  The "name" attribute of a <mark> element within the text which specified the
        point at which synthesis starts.  UTF8 string.
  
     For the other parameters, see espeak_Synth()
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
(* Const before type ignored *)
  function espeak_Key(key_name:Pchar):espeak_ERROR;cdecl;external External_library name 'espeak_Key';

  { Speak the name of a keyboard key.
     If key_name is a single character, it speaks the name of the character.
     Otherwise, it speaks key_name as a text string.
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
  function espeak_Char(character:pWideChar):espeak_ERROR;cdecl;external External_library name 'espeak_Char';

  { Speak the name of the given character
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
  {********************* }
  {  Speech Parameters   }
  {********************* }
  { internal use  }
  { reserved for misc. options.  not yet used }
  { internal use  }
  { internal use  }
  { internal, 1=mbrola }
  { last enum  }

  type
    espeak_PARAMETER = (espeakSILENCE = 0,espeakRATE = 1,
      espeakVOLUME = 2,espeakPITCH = 3,
      espeakRANGE = 4,espeakPUNCTUATION = 5,
      espeakCAPITALS = 6,espeakWORDGAP = 7,
      espeakOPTIONS = 8,espeakINTONATION = 9,
      espeakRESERVED1 = 10,espeakRESERVED2 = 11,
      espeakEMPHASIS,espeakLINELENGTH,espeakVOICETYPE,
      N_SPEECH_PARAM);

    espeak_PUNCT_TYPE = (espeakPUNCT_NONE = 0,espeakPUNCT_ALL = 1,
      espeakPUNCT_SOME = 2);

  function espeak_SetParameter(parameter:espeak_PARAMETER; value:longint; relative:longint):espeak_ERROR;cdecl;external External_library name 'espeak_SetParameter';

  { Sets the value of the specified parameter.
     relative=0   Sets the absolute value of the parameter.
     relative=1   Sets a relative value of the parameter.
  
     parameter:
        espeakRATE:    speaking speed in word per minute.  Values 80 to 450.
  
        espeakVOLUME:  volume in range 0-200 or more.
                       0=silence, 100=normal full volume, greater values may produce amplitude compression or distortion
  
        espeakPITCH:   base pitch, range 0-100.  50=normal
  
        espeakRANGE:   pitch range, range 0-100. 0-monotone, 50=normal
  
        espeakPUNCTUATION:  which punctuation characters to announce:
           value in espeak_PUNCT_TYPE (none, all, some),
           see espeak_GetParameter() to specify which characters are announced.
  
        espeakCAPITALS: announce capital letters by:
           0=none,
           1=sound icon,
           2=spelling,
           3 or higher, by raising pitch.  This values gives the amount in Hz by which the pitch
              of a word raised to indicate it has a capital letter.
  
        espeakWORDGAP:  pause between words, units of 10mS (at the default speed)
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
  function espeak_GetParameter(parameter:espeak_PARAMETER; current:longint):longint;cdecl;external External_library name 'espeak_GetParameter';

  { current=0  Returns the default value of the specified parameter.
     current=1  Returns the current value of the specified parameter, as set by SetParameter()
   }
(* Const before type ignored *)
  function espeak_SetPunctuationList(punctlist:pWideChar):espeak_ERROR;cdecl;external External_library name 'espeak_SetPunctuationList';

  { Specified a list of punctuation characters whose names are to be spoken when the
     value of the Punctuation parameter is set to "some".
  
     punctlist:  A list of character codes, terminated by a zero character.
  
     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
  const
    espeakPHONEMES_SHOW = $01;    
    espeakPHONEMES_IPA = $02;    
    espeakPHONEMES_TRACE = $08;    
    espeakPHONEMES_MBROLA = $10;    
    espeakPHONEMES_TIE = $80;

type
pFile = ^file;

  procedure espeak_SetPhonemeTrace(phonememode:longint; stream:PFILE);cdecl;external External_library name 'espeak_SetPhonemeTrace';

  { phonememode:  Controls the output of phoneme symbols for the text
        bits 0-2:
           value=0  No phoneme output (default)
           value=1  Output the translated phoneme symbols for the text
           value=2  as (1), but produces IPA phoneme names rather than ascii
        bit 3:   output a trace of how the translation was done (showing the matching rules and list entries)
        bit 4:   produce pho data for mbrola
        bit 7:   use (bits 8-23) as a tie within multi-letter phonemes names
        bits 8-23:  separator character, between phoneme names
  
     stream   output stream for the phoneme symbols (and trace).  If stream=NULL then it uses stdout.
   }
(* Const before type ignored *)
(* Const before type ignored *)
  function espeak_TextToPhonemes(textptr:Ppointer; textmode:longint; phonememode:longint):pChar;cdecl;external External_library name 'espeak_TextToPhonemes';

  { Translates text into phonemes.  Call espeak_SetVoiceByName() first, to select a language.

     It returns a pointer to a character string which contains the phonemes for the text up to
     end of a sentence, or comma, semicolon, colon, or similar punctuation.
  
     textptr: The address of a pointer to the input text which is terminated by a zero character.
        On return, the pointer has been advanced past the text which has been translated, or else set
        to NULL to indicate that the end of the text has been reached.
  
     textmode: Type of character codes, one of:
           espeakCHARS_UTF8     UTF8 encoding
           espeakCHARS_8BIT     The 8 bit ISO-8859 character set for the particular language.
           espeakCHARS_AUTO     8 bit or UTF8  (this is the default)
           espeakCHARS_WCHAR    Wide characters (wchar_t)
           espeakCHARS_16BIT    16 bit characters.
  
     phoneme_mode
              bit 1:   0=eSpeak's ascii phoneme names, 1= International Phonetic Alphabet (as UTF-8 characters).
          bit 7:   use (bits 8-23) as a tie within multi-letter phonemes names
          bits 8-23:  separator character, between phoneme names
  
   }
(* Const before type ignored *)
  procedure espeak_CompileDictionary(path:Pchar; log:PFILE; flags:longint);cdecl;external External_library name 'espeak_CompileDictionary';

  { Compile pronunciation dictionary for a language which corresponds to the currently
     selected voice.  The required voice should be selected before calling this function.
  
     path:  The directory which contains the language's '_rules' and '_list' files.
            'path' should end with a path separator character ('/').
     log:   Stream for error reports and statistics information. If log=NULL then stderr will be used.
  
     flags:  Bit 0: include source line information for debug purposes (This is displayed with the
            -X command line option).
   }
  {********************* }
  {   Voice Selection    }
  {********************* }
  { voice table }
(* Const before type ignored *)
  { a given name for this voice. UTF8 string. }
(* Const before type ignored *)
  { list of pairs of (byte) priority + (string) language (and dialect qualifier) }
(* Const before type ignored *)
  { the filename for this voice within espeak-ng-data/voices }
  { 0=none 1=male, 2=female, }
  { 0=not specified, or age in years }
  { only used when passed as a parameter to espeak_SetVoiceByProperties }
  { for internal use }
  { for internal use }
  { for internal use }

  type
    pEspeak_VOICE = ^espeak_VOICE;
    ppEspeak_VOICE = ^pespeak_VOICE;
    espeak_VOICE = record
        name : pChar;
        languages : pChar;
        identifier : pChar;
        gender : byte;
        age : byte;
        variant : byte;
        xx1 : byte;
        score : longint;
        spare : pointer;
      end;
  { Note: The espeak_VOICE structure is used for two purposes:
    1.  To return the details of the available voices.
    2.  As a parameter to  espeak_SetVoiceByProperties() in order to specify selection criteria.

     In (1), the "languages" field consists of a list of (UTF8) language names for which this voice
     may be used, each language name in the list is terminated by a zero byte and is also preceded by
     a single byte which gives a "priority" number.  The list of languages is terminated by an
     additional zero byte.

     A language name consists of a language code, optionally followed by one or more qualifier (dialect)
     names separated by hyphens (eg. "en-uk").  A voice might, for example, have languages "en-uk" and
     "en".  Even without "en" listed, voice would still be selected for the "en" language (because
     "en-uk" is related) but at a lower priority.

     The priority byte indicates how the voice is preferred for the language. A low number indicates a
     more preferred voice, a higher number indicates a less preferred voice.

     In (2), the "languages" field consists simply of a single (UTF8) language name, with no preceding
     priority byte.
   }
(* Const before type ignored *)

  function espeak_ListVoices(voice_spec:Pespeak_VOICE):ppespeak_VOICE;cdecl;external External_library name 'espeak_ListVoices';

  { Reads the voice files from espeak-ng-data/voices and creates an array of espeak_VOICE pointers.
     The list is terminated by a NULL pointer

     If voice_spec is NULL then all voices are listed.
     If voice spec is given, then only the voices which are compatible with the voice_spec
     are listed, and they are listed in preference order.
   }
(* Const before type ignored *)
  function espeak_SetVoiceByFile(filename:Pchar):espeak_ERROR;cdecl;external External_library name 'espeak_SetVoiceByFile';

  { Loads a voice given the file path.  Language is not considered.
     "filename" is a UTF8 string.

     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
(* Const before type ignored *)
  function espeak_SetVoiceByName(name:Pchar):espeak_ERROR;cdecl;external External_library name 'espeak_SetVoiceByName';

  { Searches for a voice with a matching "name" field.  Language is not considered.
     "name" is a UTF8 string.

     Return: EE_OK: operation achieved
             EE_BUFFER_FULL: the command can not be buffered;
               you may try after a while to call the function again.
             EE_INTERNAL_ERROR.
   }
  function espeak_SetVoiceByProperties(voice_spec:Pespeak_VOICE):espeak_ERROR;cdecl;external External_library name 'espeak_SetVoiceByProperties';

  { An espeak_VOICE structure is used to pass criteria to select a voice.  Any of the following
     fields may be set:
  
     name     NULL, or a voice name
  
     languages  NULL, or a single language string (with optional dialect), eg. "en-uk", or "en"
  
     gender   0=not specified, 1=male, 2=female
  
     age      0=not specified, or an age in years
  
     variant  After a list of candidates is produced, scored and sorted, "variant" is used to index
              that list and choose a voice.
              variant=0 takes the top voice (i.e. best match). variant=1 takes the next voice, etc
   }
  function espeak_GetCurrentVoice:pespeak_VOICE;cdecl;external External_library name 'espeak_GetCurrentVoice';

  { Returns the espeak_VOICE data for the currently selected voice.
     This is not affected by temporary voice changes caused by SSML elements such as <voice> and <s>
   }
  function espeak_Cancel:espeak_ERROR;cdecl;external External_library name 'espeak_Cancel';

  { Stop immediately synthesis and audio output of the current text. When this
     function returns, the audio output is fully stopped and the synthesizer is ready to
     synthesize a new message.

     Return: EE_OK: operation achieved
             EE_INTERNAL_ERROR.
   }
  function espeak_IsPlaying:longint;cdecl;external External_library name 'espeak_IsPlaying';

  { Returns 1 if audio is played, 0 otherwise.
   }
  function espeak_Synchronize:espeak_ERROR;cdecl;external External_library name 'espeak_Synchronize';

  { This function returns when all data have been spoken.
     Return: EE_OK: operation achieved
             EE_INTERNAL_ERROR.
   }
  function espeak_Terminate:espeak_ERROR;cdecl;external External_library name 'espeak_Terminate';

  { last function to be called.
     Return: EE_OK: operation achieved
             EE_INTERNAL_ERROR.
   }
(* Const before type ignored *)
(* Const before type ignored *)
  function espeak_Info(path_data:PPchar):pChar;cdecl;external External_library name 'espeak_Info';

  { Returns the version number string.
     path_data  returns the path to espeak_data
   }
{$endif}

implementation


end.
