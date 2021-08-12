unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, registry;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    general: TTabSheet;
    favoris: TTabSheet;
    e_mail: TTabSheet;
    login_label: TLabel;
    passwd_label: TLabel;
    login: TEdit;
    passwd: TEdit;
    about: TTabSheet;
    modem_label: TLabel;
    modem: TEdit;
    page_perso_label: TLabel;
    page_perso: TEdit;
    sexe_label: TLabel;
    age_label: TLabel;
    age: TEdit;
    zone_label: TLabel;
    zone: TEdit;
    Panel1: TPanel;
    registerida_label: TLabel;
    registerida: TEdit;
    registeridb_label: TLabel;
    registeridb: TEdit;
    registeridc_label: TLabel;
    registeridc: TEdit;
    registeridd_label: TLabel;
    registeridd: TEdit;
    passwd_auto: TCheckBox;
    shortcut: TCheckBox;
    etat_label: TLabel;
    creee: TRadioButton;
    non_cree: TRadioButton;
    adresse_server_label: TLabel;
    adresse_server: TEdit;
    utilisateur_mail_label: TLabel;
    utilisateur_mail: TEdit;
    passwd_mail_label: TLabel;
    passwd_mail: TEdit;
    server_ip_label: TLabel;
    server_ip: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    save: TButton;
    cancel: TButton;
    exit: TButton;
    Label7: TLabel;
    sexe: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées}
    function LoadOrekaKey() : boolean ;
  public
    { Déclarations publiques}
  end;

  // enregistrement pour les favoris !
  RFavorisListe = record
      nom : string ;
      url : string ;
  end ;
var
  Form1: TForm1;
const
  OREKAPATH : string = 'software\ineo\' ;
implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
if LoadOrekaKey
then
    Form1.Caption := 'reussi' ;
end;

function TForm1.LoadOrekaKey() : boolean ;
var Registre : TRegistry ;
begin
    Registre := TRegistry.Create ;
    // par défaut on n'a pas réussi
    LoadOrekaKey := False ;
    try
        // définit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATH)
        then begin
                 login.text := Registre.ReadString('Login') ;
                 passwd.text := Registre.ReadString('Passwd') ;
                 modem.text := Registre.ReadString('Modem') ;
                 page_perso.text := Registre.ReadString('PagePersoURL') ;

// à améliorer
                 sexe.text := Registre.ReadString('Sexe') ;
                 age.text := Registre.ReadString('TrancheAge') ;
// fin
                 zone.text := Registre.ReadString('Zone') ;
                 registerida.text := Registre.ReadString('RegisterIDA') ;
                 registeridb.text := Registre.ReadString('RegisterIDB') ;
                 registeridc.text := Registre.ReadString('RegisterIDC') ;
                 registeridd.text := Registre.ReadString('RegisterIDD') ;

                 { J'ai choisi de comparer les valeurs entières et non
                   pas la chaîne. Sait-on jamais ! }
                 if (StrToInt(Registre.ReadString('SavePasswd')) = 1)
                 then
                     passwd_auto.Checked := True
                 else
                     passwd_auto.Checked := False ;

                 if (StrToInt(Registre.ReadString('ShortCut')) = 1)
                 then
                     shortcut.Checked := True
                 else
                     shortcut.Checked := False ;

                 // Panneau E-Mail
                 if (Registre.ReadString('EMail') = 'non_cree')
                 then
                     non_cree.checked := true
                 else
                     creee.checked := true ;

                 utilisateur_mail.text := Registre.ReadString('POP3Login') ;
                 passwd_mail.text := Registre.ReadString('POP3Passwd') ;
                 adresse_server.text := Registre.ReadString('MailerPath') ;
                 server_ip.text := Registre.ReadString('POP3Server') ;

                 // On a réussi !
                 LoadOrekaKey := True ;
             end ;

    finally
        // libère le registre
        Registre.Free ;
    end ;
end ;


end.
