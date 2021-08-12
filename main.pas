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
    Favoris_list: TListBox;
    favoris_name_label: TLabel;
    favoris_name: TEdit;
    url_label: TLabel;
    favoris_url: TEdit;
    Image1: TImage;
    sexe_combo: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Favoris_listClick(Sender: TObject);
    procedure favoris_nameChange(Sender: TObject);
    procedure favoris_urlChange(Sender: TObject);
    procedure exitClick(Sender: TObject);
    procedure creeeClick(Sender: TObject);
    procedure non_creeClick(Sender: TObject);
  private
    { Déclarations privées}
    function LoadOrekaKey() : boolean ;
    function LoadOrekaFavoris() : boolean ;
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
  // liste des favoris
  ListeFavoris : array[1..20] of RFavorisListe ;
const
  OREKAPATH : string = 'software\ineo\' ;
  OREKAPATHFAVORIS : string = 'software\ineo\favoris\' ;
implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
//if LoadOrekaKey() = False
//then

//if LoadOrekaFavoris = False
//then
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

                 if (Registre.ReadString('Sexe') = 'sexem')
                 then
                     sexe_combo.ItemIndex := 0
                 else if (Registre.ReadString('Sexe') = 'sexef')
                 then
                     sexe_combo.ItemIndex := 1
                 else
                     sexe_combo.ItemIndex := 2 ;
// à améliorer
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

function TForm1.LoadOrekaFavoris() : boolean ;
var Registre : TRegistry ;
    i : integer ;
begin
    Registre := TRegistry.Create ;
    // par défaut on n'a pas réussi
    LoadOrekaFavoris := False ;
    try
        // définit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATHFAVORIS)
        then begin
            for i := 1 to 20 do
            begin
                ListeFavoris[i].nom := Registre.ReadString('FavorisMenu'+IntToStr(i)) ;
                ListeFavoris[i].url := Registre.ReadString('FavorisURL'+IntToStr(i)) ;;
            end ;

            // On a réussi !
            LoadOrekaFavoris := True ;
        end ;
    finally
        // libère le registre
        Registre.Free ;
    end ;

end ;

procedure TForm1.Favoris_listClick(Sender: TObject);
var i : integer ;
begin
    for i := 0 to 19 do
    begin
        if favoris_list.Selected[i]
        then begin
            favoris_name.text := ListeFavoris[i+1].nom ;
            favoris_url.text  := ListeFavoris[i+1].url ;
        end ;
    end ;
end;

procedure TForm1.favoris_nameChange(Sender: TObject);
var i : integer ;
begin
    // parcours la liste
    for i := 0 to 19 do
    begin
        if favoris_list.Selected[i]
        // si l'élément i est sélectionné
        then begin
            ListeFavoris[i+1].nom := favoris_name.text ;
        end ;
    end ;
end;

procedure TForm1.favoris_urlChange(Sender: TObject);
var i : integer ;
begin
    for i := 0 to 19 do
    begin
        if favoris_list.Selected[i]
        then begin
            ListeFavoris[i+1].url := favoris_url.text ;
        end ;
    end ;
end;

procedure TForm1.exitClick(Sender: TObject);
begin
    Application.Terminate ;
end;

procedure TForm1.non_creeClick(Sender: TObject);
begin
    utilisateur_mail.Enabled := False ;
    passwd_mail.Enabled := False ;
    adresse_server.Enabled := False ;
    server_ip.Enabled := False ;
end;

procedure TForm1.creeeClick(Sender: TObject);
begin
    utilisateur_mail.Enabled := True ;
    passwd_mail.Enabled := True ;
    adresse_server.Enabled := True ;
    server_ip.Enabled := True ;
end;

end.
