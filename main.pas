{*
 * Or�ka Tracker
 * Version : 0.4
 * Date    : 4/02/2001
 *
 * Ce programme est prot�g� par la loi du GPL. R�f�r�vous au fichier GNU_LICENCE.TXT
 * pour plus d'information.
 *}
unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, registry, Printers, IniFiles;

type
  TForm1 = class(TForm)
    save: TButton;
    cancel: TButton;
    quitter: TButton;
    table: TPageControl;
    general: TTabSheet;
    login_label: TLabel;
    passwd_label: TLabel;
    modem_label: TLabel;
    page_perso_label: TLabel;
    sexe_label: TLabel;
    age_label: TLabel;
    zone_label: TLabel;
    registerida_label: TLabel;
    registeridb_label: TLabel;
    registeridc_label: TLabel;
    registeridd_label: TLabel;
    login: TEdit;
    passwd: TEdit;
    modem: TEdit;
    page_perso: TEdit;
    Panel1: TPanel;
    registerida: TEdit;
    registeridb: TEdit;
    registeridc: TEdit;
    registeridd: TEdit;
    passwd_auto: TCheckBox;
    shortcut: TCheckBox;
    sexe_combo: TComboBox;
    favoris: TTabSheet;
    favoris_name_label: TLabel;
    url_label: TLabel;
    Favoris_list: TListBox;
    favoris_name: TEdit;
    favoris_url: TEdit;
    e_mail: TTabSheet;
    etat_label: TLabel;
    adresse_server_label: TLabel;
    utilisateur_mail_label: TLabel;
    passwd_mail_label: TLabel;
    server_ip_label: TLabel;
    creee: TRadioButton;
    non_cree: TRadioButton;
    adresse_server: TEdit;
    utilisateur_mail: TEdit;
    passwd_mail: TEdit;
    server_ip: TEdit;
    edition: TTabSheet;
    divers: TTabSheet;
    save_texte: TButton;
    imprimer: TButton;
    save_inst: TButton;
    zone: TComboBox;
    age: TComboBox;
    about: TTabSheet;
    Image2: TImage;
    Label1: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    fistconnexion: TCheckBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    e_mail_adresse: TEdit;
    e_mail_label: TLabel;
    load_inst: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Favoris_listClick(Sender: TObject);
    procedure favoris_nameChange(Sender: TObject);
    procedure favoris_urlChange(Sender: TObject);
    procedure quitterClick(Sender: TObject);
    procedure creeeClick(Sender: TObject);
    procedure non_creeClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure saveClick(Sender: TObject);
    procedure save_texteClick(Sender: TObject);
    procedure imprimerClick(Sender: TObject);
    procedure save_instClick(Sender: TObject);
    procedure load_instClick(Sender: TObject);
  private
    { D�clarations priv�es}
    function LoadOrekaKey() : boolean ;
    function LoadOrekaFavoris() : boolean ;
    function SaveOrekaKey() : boolean;
    function SaveOrekaFavoris() : boolean ;
    function SaveFile(var Fichier : TextFile) : boolean ;
    function RestaureOreka(FichierIni : TIniFile) : boolean ;
    function REstaureOrekaFavoris(FichierIni : TIniFile) : boolean ;
    { Ci-dessous les seules fonctions compatibles avec les versions
      ant�rieures et � venir d'Or�ka }
    function SaveOrekaIniFile(FichierIni : TIniFile) : boolean ;
    function SaveOrekaFavorisIniFile(FichierIni : TIniFile) : boolean ;
  public
    { D�clarations publiques}
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
  VERSION : string = '0.4' ;
implementation

{$R *.DFM}

{***************************************************************
 * Proc�dure appel�e lors de la cr�ation de la feuille et donc *
 * lors du lancement du programme                              *
 ***************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
begin
    LoadOrekaKey() ;
    LoadOrekaFavoris() ;
    Label8.Caption := Label8.Caption + ' ' + VERSION ;
end;

{***************************************************************
 * Fonction qui charge les valeurs d'Or�ka se trouvant normal- *
 * lement dans la base de registre � l'adresse HKEY_LOCAL_MACHINE
 * \Software\Ineo\                                             *
 ***************************************************************
 * Retourne True si le chargement s'est bien pass�, sinon False*
 ***************************************************************}
function TForm1.LoadOrekaKey() : boolean ;
var Registre : TRegistry ;
    strTemp  : string ;   // permet d'ajouter le '-' � l'�ge
begin
    Registre := TRegistry.Create ;
    // par d�faut on n'a pas r�ussi
    LoadOrekaKey := False ;
    try
        // d�finit la clef racine
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
                     sexe_combo.Text := Registre.ReadString('Sexe') ;

                 age.text := Registre.ReadString('TrancheAge') ;
                 // ajoute 1 caract�re pour mettre un '-' au milieu
                 strTemp := age.text + ' ' ;
                 // d�cale les caract�re
                 strTemp[5] := strTemp[4] ;
                 strTemp[4] := strTemp[3] ;
                 // ajoute le '-'
                 strTemp[3] := '-' ;
                 // affecte le r�sultat
                 age.text := strTemp ;

                 zone.text := Registre.ReadString('Zone') ;
                 registerida.text := Registre.ReadString('RegisterIDA') ;
                 registeridb.text := Registre.ReadString('RegisterIDB') ;
                 registeridc.text := Registre.ReadString('RegisterIDC') ;
                 registeridd.text := Registre.ReadString('RegisterIDD') ;

                 { J'ai choisi de comparer les valeurs enti�res et non
                   pas la cha�ne. Sait-on jamais ! }
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

                 if (Registre.ReadString('FistConnexion') = '1')
                 then
                     fistconnexion.Checked := True
                 else
                     fistconnexion.Checked := False;
                 // On a r�ussi !
                 LoadOrekaKey := True ;
             end ;

    finally
        // lib�re le registre
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Fonction qui charge les valeurs d'Or�ka se trouvant normal- *
 * lement dans la base de registre � l'adresse HKEY_LOCAL_MACHINE
 * \Software\Ineo\favoris                                      *
 ***************************************************************
 * Retourne True si le chargement s'est bien pass�, sinon False*
 ***************************************************************}
function TForm1.LoadOrekaFavoris() : boolean ;
var Registre : TRegistry ;
    i : integer ;
begin
    Registre := TRegistry.Create ;
    // par d�faut on n'a pas r�ussi
    LoadOrekaFavoris := False ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATHFAVORIS)
        then begin
            for i := 1 to 20 do
            begin
                ListeFavoris[i].nom := Registre.ReadString('FavorisMenu'+IntToStr(i)) ;
                ListeFavoris[i].url := Registre.ReadString('FavorisURL'+IntToStr(i)) ;;
            end ;

            // On a r�ussi !
            LoadOrekaFavoris := True ;
        end ;
    finally
        // lib�re le registre
        Registre.Free ;
    end ;

end ;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on clique sur la liste des *
 * favoris. Elle charge alors les param�tres du favoris cliqu� *
 ***************************************************************}
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

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on modifie le nom du favoris
 * . Il est mis � jour dans la table interne du programme      *
 ***************************************************************}
procedure TForm1.favoris_nameChange(Sender: TObject);
var i : integer ;
begin
    // parcours la liste
    for i := 0 to 19 do
    begin
        if favoris_list.Selected[i]
        // si l'�l�ment i est s�lectionn�
        then begin
            ListeFavoris[i+1].nom := favoris_name.text ;
        end ;
    end ;
end;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on modifie l'url du favoris*
 * . Il est mis � jour dans la table interne du programme      *
 ***************************************************************}
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

{***************************************************************
 * Proc�dure appel�e qu'on on clique sur le bouton quitter     *
 ***************************************************************}
procedure TForm1.quitterClick(Sender: TObject);
begin
    Application.Terminate ;
end;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on clique sur l'option     *
 * Non cr��e du e-mail. Elle d�sactive les param�tres en       *
 * relation.                                                   *
 ***************************************************************}
procedure TForm1.non_creeClick(Sender: TObject);
begin
    e_mail_adresse.Enabled := False ;
    utilisateur_mail.Enabled := False ;
    passwd_mail.Enabled := False ;
    adresse_server.Enabled := False ;
    server_ip.Enabled := False ;
end;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on clique sur l'option     *
 * Cr��e du e-mail. Elle active les param�tres en relation.    *
 ***************************************************************}
procedure TForm1.creeeClick(Sender: TObject);
begin
    e_mail_adresse.Enabled := True ;
    utilisateur_mail.Enabled := True ;
    passwd_mail.Enabled := True ;
    adresse_server.Enabled := True ;
    server_ip.Enabled := True ;
end;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on clique sur le bouton    *
 * Annuler les modifications                                   *
 ***************************************************************}
procedure TForm1.cancelClick(Sender: TObject);
begin
    if Application.MessageBox('�tes-vous s�r de vouloir annuler les modifications ?',
                              'Annulation', MB_OKCANCEL + MB_ICONQUESTION ) = IDOK
    then begin
         // R�appel les fonctions d'initialisations
         LoadOrekaKey() ;
         LoadOrekaFavoris() ;
    end ;
end;

{***************************************************************
 * Fonction qui sauve les valeurs d'Or�ka se trouvant normal-  *
 * lement dans la base de registre � l'adresse HKEY_LOCAL_MACHINE
 * \Software\Ineo\favoris                                      *
 ***************************************************************
 * Retourne True si le chargement s'est bien pass�, sinon False*
 ***************************************************************}
function TForm1.SaveOrekaFavoris() : boolean ;
var Registre : TRegistry ;
    i : integer ;
begin
    Registre := TRegistry.Create ;
    // par d�faut on n'a pas r�ussi
    SaveOrekaFavoris := False ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATHFAVORIS)
        then begin
            for i := 1 to 20 do
            begin
                Registre.WriteString('FavorisMenu'+IntToStr(i), ListeFavoris[i].nom) ;
                Registre.WriteString('FavorisURL'+IntToStr(i), ListeFavoris[i].url) ;
            end ;

            // On a r�ussi !
            SaveOrekaFavoris := True ;
        end ;
    finally
        // lib�re le registre
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Fonction qui sauve les valeurs d'Or�ka se trouvant normal-  *
 * lement dans la base de registre � l'adresse HKEY_LOCAL_MACHINE
 * \Software\Ineo\                                             *
 ***************************************************************
 * Retourne True si le chargement s'est bien pass�, sinon False*
 ***************************************************************}
function TForm1.SaveOrekaKey() : boolean ;
var Registre : TRegistry ;
    strTemp  : string ;   // permet d'enlever le '-' � l'�ge
    strTemp2 : string ;   // idem
    i        : integer ;  // idem
begin
    Registre := TRegistry.Create ;
    // par d�faut on n'a pas r�ussi
    SaveOrekaKey := False ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATH)
        then begin
                 Registre.WriteString('Login', login.text) ;
                 Registre.WriteString('Passwd', passwd.text) ;
                 Registre.WriteString('Modem', modem.text) ;
                 Registre.WriteString('PagePersoURL', page_perso.text) ;

                 if (sexe_combo.ItemIndex = 0)
                 then
                     // masculin
                     Registre.WriteString('Sexe', 'sexem' )
                 else if (sexe_combo.ItemIndex = 1)
                 then
                     // f�minin
                     Registre.WriteString('Sexe', 'sexef')
                 else
                     // personnaliser
                     Registre.WriteString('Sexe', sexe_combo.Text) ;

                 // ajoute 1 caract�re pour mettre un '-' au milieu
                 strTemp := age.text ;
                 // d�cale les caract�re
                 strTemp[3] := strTemp[4] ;
                 strTemp[4] := strTemp[5] ;
                 // enleve le '-'
                 strTemp2 := '' ;
                 for i := 1 to 4 do
                     strTemp2 := strTemp2 + strTemp[i] ;
                 // affecte le r�sultat
                 Registre.WriteString('TrancheAge', strTemp2) ;

                 Registre.WriteString('Zone', zone.text) ;
                 Registre.WriteString('RegisterIDA', registerida.text) ;
                 Registre.WriteString('RegisterIDB', registeridb.text) ;
                 Registre.WriteString('RegisterIDC', registeridc.text) ;
                 Registre.WriteString('RegisterIDD', registeridd.text) ;

                 // sauvegerde automatique ?
                 if (passwd_auto.Checked = True)
                 then
                     Registre.WriteString('SavePasswd', '1')
                 else
                     Registre.WriteString('SavePasswd', '0') ;

                 // Raccourci clavier ?
                 if (shortcut.Checked = True)
                 then
                     Registre.WriteString('ShortCut', '1')
                 else
                     Registre.WriteString('ShortCut', '0') ;

                 // Panneau E-Mail
                 if (non_cree.checked = true)
                 then begin
                     // si l'e-mail n'est pas cr��, on ne sauve
                     // pas le reste !
                     Registre.WriteString('EMail', 'non_cree') ;
                     Registre.WriteString('POP3Login', 'non_cree') ;
                     Registre.WriteString('POP3Passwd', 'non_cree') ;
                     end
                 else begin
                     Registre.WriteString('EMail', e_mail_adresse.Text) ;
                     Registre.WriteString('POP3Login', utilisateur_mail.text) ;
                     Registre.WriteString('POP3Passwd', passwd_mail.text) ;
                     Registre.WriteString('MailerPath', adresse_server.text) ;
                     Registre.WriteString('POP3Server', server_ip.text) ;
                     end ;

                 if (fistconnexion.Checked = True)
                 then
                     Registre.WriteString('FistConnexion', '1')
                 else
                     Registre.WriteString('FistConnexion', '0') ;

                 // On a r�ussi !
                 SaveOrekaKey := True ;
             end ;

    finally
        // lib�re le registre
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Proc�dure qui est appel�e lorsqu'on clique sur le bouton    *
 * enregistrer.
 * Elle enregistre les param�tres dans la base de registre
 ***************************************************************}
procedure TForm1.saveClick(Sender: TObject);
begin
    if (Application.MessageBox('�tes-vous s�r(e) de vouloir enregistrer les modifications ?',
                               'Enregistrer',MB_ICONQUESTION + MB_YESNO ) = IDYES )
    then begin
        if (SaveOrekaFavoris() = False)
        then
            Application.MessageBox('Impossible d''enregistrer les favoris d''Or�ka !',
                                   'Erreur',MB_ICONERROR + MB_OK ) ;
        if (SaveOrekaKey() = False)
        then
            Application.MessageBox('Impossible les param�tres courant d''Or�ka !',
                                   'Erreur',MB_ICONERROR + MB_OK ) ;
    end ;

end;

{***************************************************************
 * Fonction qui est appel�e pour g�n�rer un rapport
 * Renvoit True si r�ussi, sinon False
 ***************************************************************}
function TForm1.SaveFile(var Fichier : TextFile) : boolean ;
var i : integer ;
begin
    SaveFile := False ;
    try
        // g�n�ral
        Writeln(Fichier, 'Or�ka Tracker');
        Writeln(Fichier, '-------------') ;
        Writeln(Fichier, '');
        Writeln(Fichier, 'Version '+ VERSION);
        Writeln(Fichier, '');
        Writeln(Fichier, 'Date de g�n�ration : ' + DateToStr(Date)) ;
        Writeln(Fichier, '');
        Writeln(Fichier, 'Nom d''utilisateur : ' + login.Text);
        Writeln(Fichier, 'Mot de passe : ' + passwd.Text);
        Writeln(Fichier, 'Modem utilis� : ' + modem.Text);
        Writeln(Fichier, 'Adresse page perso : ' + page_perso.Text);
        Writeln(Fichier, 'Votre sexe : ' + sexe_combo.Text);
        Writeln(Fichier, 'Votre tranche d''�ge : ' + age.Text);
        Writeln(Fichier, 'Zone locale de tel : ' + zone.Text);
        Writeln(Fichier, 'Register ID A : ' + registerida.Text);
        Writeln(Fichier, 'Register ID B : ' + registeridb.Text);
        Writeln(Fichier, 'Register ID C : ' + registeridc.Text);
        Writeln(Fichier, 'Register ID D : ' + registeridd.Text);
        Write(Fichier, 'Enregistrement automatique du mot de passe : ');
        if (passwd_auto.Checked = True)
        then
            Writeln(Fichier, 'oui')
        else
            Writeln(Fichier, 'non') ;

        Write(Fichier, 'Raccourci clavier : ');
        if (shortcut.Checked = True)
        then
            Writeln(Fichier, 'oui')
        else
            Writeln(Fichier, 'non') ;

        Writeln(Fichier, '');

        // liste des favoris
        for i := 1 to 20 do
            Writeln(Fichier, 'Favoris n�' + IntToStr(i) + ' : ' + ListeFavoris[i].nom + ', ' + ListeFavoris[i].url) ;

        // e-mail
        if (non_cree.checked = true)
        then begin
             // si l'e-mail n'est pas cr��, on ne sauve
             // pas le reste !
             Writeln(Fichier, 'E-mail : non cr�e') ;
             Writeln(Fichier, 'POP3Login : non cr�e') ;
             Writeln(Fichier, 'POP3Passwd : non cr�e') ;
             end
        else begin
             Writeln(Fichier, 'E-mail : ' + e_mail_adresse.Text) ;
             Writeln(Fichier, 'POP3Login : ' + utilisateur_mail.text) ;
             Writeln(Fichier, 'POP3Passwd : ' + passwd_mail.text) ;
             Writeln(Fichier, 'MailerPath : ' + adresse_server.text) ;
             Writeln(Fichier, 'POP3Server : ' + server_ip.text) ;
             end ;

        // divers
        Write(Fichier, 'Connexion poing : ') ;
        if (fistconnexion.Checked = True)
        then
            Writeln(Fichier, 'oui')
        else
            Writeln(Fichier, 'non') ;

        SaveFile := True ;
    finally
    end ;
end;

{***************************************************************
 * Proc�dure qui va enregistrer le rapport g�n�r� par la fonction
 * SaveFile(...) dans un fichier texte
 ***************************************************************}
procedure TForm1.save_texteClick(Sender: TObject);
Var  FichierTexte    : TextFile;   {d�clare une variable fichier}
     EnregistreDialog : TSaveDialog ;
begin
     // Cr�er la bo�te de dialogue
     EnregistreDialog := TSaveDialog.Create(Application) ;
     // affecte les param�tres
     EnregistreDialog.DefaultExt := '*.txt' ;
     EnregistreDialog.Filter := 'Fichier texte|*.txt|Fichier log|*.log|Tous fichiers|*.*' ;
     EnregistreDialog.Title := 'Sauvegarde des param�tres Or�ka' ;

     try
         if (EnregistreDialog.Execute)
         then begin
             if (FileExists(EnregistreDialog.FileName) = True)
             then
                  if ( Application.MessageBox('Le fichier existe d�j� ! Voulez-vous quand m�me continuer ?', 'Avertissement', MB_ICONQUESTION + MB_YESNO) = IDNO)
                  then
                       // on quitte. L'instruction finally sera ex�cut�e quand m�me
                      Exit;

// v�rifier la possibiliter d'enregistrement
             AssignFile(FichierTexte, EnregistreDialog.FileName);   {affecte PrintText � l'imprimante}
             Rewrite(FichierTexte);     {cr�e puis ouvre un fichier en sortie}
             //enregistre
             if (SaveFile(FichierTexte) = False)
             then
                Application.MessageBox('Impossible d''enregistrer les donn�es dans un fichier !',
                                       'Erreur',MB_ICONERROR + MB_OK ) ;
             CloseFile(FichierTexte) ;
        end ;
     finally
         EnregistreDialog.Free ;
     end ;

end;

{***************************************************************
 * Proc�dure qui va imprimer le rapport g�n�r� par la fonction
 * SaveFile(...).
 ***************************************************************}
procedure TForm1.imprimerClick(Sender: TObject);
Var   PrintText: TextFile;   {d�clare une variable fichier}
begin
    AssignPrn(PrintText);   {affecte PrintText � l'imprimante}
    Rewrite(PrintText);     {cr�e puis ouvre un fichier en sortie}
    if (SaveFile(PrintText) = False)
    then
         Application.MessageBox('Impossible d''imprimer les donn�es !',
                                 'Erreur',MB_ICONERROR + MB_OK ) ;

    CloseFile(PrintText); {ferme la variable imprimante}
end;

{***************************************************************
 * Proc�dure qui va enregistrer les param�tres d'Or�ka dans un
 * fichier ini pour une r�installation ult�rieure.
 ***************************************************************}
procedure TForm1.save_instClick(Sender: TObject);
Var FichierIni    : TIniFile ;
    EnregistreDialog : TSaveDialog ;
begin
     // Cr�er la bo�te de dialogue
     EnregistreDialog := TSaveDialog.Create(Application) ;
     // affecte les param�tres
     EnregistreDialog.DefaultExt := '*.oti' ;
     EnregistreDialog.Filter := 'Fichier texte|*.txt|Fichier Or�ka Tracker|*.oti|Tous fichiers|*.*' ;
     EnregistreDialog.Title := 'Sauvegarde des param�tres Or�ka' ;

    try
         if (EnregistreDialog.Execute)
         then begin
             if (FileExists(EnregistreDialog.FileName) = True)
             then
                  if ( Application.MessageBox('Le fichier existe d�j� ! Voulez-vous quand m�me continuer ?', 'Avertissement', MB_ICONQUESTION + MB_YESNO) = IDNO)
                  then
                       // on quitte. L'instruction finally sera ex�cut�e quand m�me
                      Exit;
                      
             // cr�er le fichier
             FichierIni := TIniFile.Create(EnregistreDialog.FileName) ;
             // Version d'Or�ka Tracker
             FichierIni.WriteString('Oreka TRacker', 'Version', VERSION) ;
             // version d'Or�ka
             FichierIni.WriteString('Oreka', 'Version', '0.632') ;
             // Appel la fonction qui �crit tous ce qu'il y a dans la base de registre
             if (SaveOrekaIniFile(FichierIni) = False) or (SaveOrekaFavorisIniFile(FichierIni) = False)
             then
                 Application.MessageBox('Erreur lors de l''enregistrement des donn�es !', 'Erreur',
                                        MB_ICONERROR + MB_OK) ;
             // d�truit la variable
             FichierIni.Free ;
         end ;
    finally
        EnregistreDialog.Free ;
    end ;
end;

{***************************************************************
 * Fonction qui est appel� pour enregistrer dans un fichier
 * type ini les param�tres d'Or�ka
 ***************************************************************}
function TForm1.SaveOrekaIniFile(FichierIni : TIniFile) : boolean ;
var Registre : TRegistry ;
    Liste    : TStringList ;
    i        : integer ;
begin
    SaveOrekaIniFile := False ;
    Registre := TRegistry.Create() ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATH)
        then begin
            Liste := TStringList.Create() ;
            { Attention, le prototype de la m�thode GetValueNames indique que
              son param�tre est un TStrings, mais seulement c'est une classe
              virtuelle. Donc, il faut utiliser TStringList}
            Registre.GetValueNames(Liste) ;
            // le nombres de parram�tres est donn� par Count
            for i := 0 to (Liste.Count - 1) do
                FichierIni.WriteString('General', Liste.Strings[i],
                                       Registre.ReadString(Liste.Strings[i]) ) ;
        end ;

    finally
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Fonction qui est appel� pour enregistrer dans un fichier
 * type ini les favoris d'Or�ka
 ***************************************************************}
function TForm1.SaveOrekaFavorisIniFile(FichierIni : TIniFile) : boolean ;
var Registre : TRegistry ;
    Liste    : TStringList ;
    i        : integer ;
begin
    SaveOrekaFavorisIniFile := False ;
    Registre := TRegistry.Create() ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATHFAVORIS)
        then begin
            Liste := TStringList.Create() ;
            { Attention, le prototype de la m�thode GetValueNames indique que
              son param�tre est un TStrings, mais seulement c'est une classe
              virtuelle. Donc, il faut utiliser TStringList }
            Registre.GetValueNames(Liste) ;
            // le nombres de parram�tres est donn� par Count
            for i := 0 to (Liste.Count - 1) do
                FichierIni.WriteString('Favoris', Liste.Strings[i],
                                       Registre.ReadString(Liste.Strings[i]) ) ;
        end ;

    finally
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Proc�dure qui est appel� lorsqu'on clique sur le boutton de
 * r�-installation des param�tre d'Or�ka
 ***************************************************************}
procedure TForm1.load_instClick(Sender: TObject);
Var FichierIni    : TIniFile ;
    OuvrirDialog : TOpenDialog ;
begin
     // Cr�er la bo�te de dialogue
     OuvrirDialog := TSaveDialog.Create(Application) ;
     // affecte les param�tres
     OuvrirDialog.DefaultExt := '*.oti' ;
     OuvrirDialog.Filter := 'Fichier texte|*.txt|Fichier Or�ka Tracker|*.oti|Tous fichiers|*.*' ;
     OuvrirDialog.Title := 'Sauvegarde des param�tres Or�ka' ;

    try
         if (OuvrirDialog.Execute)
         then begin
             // cr�er le fichier
             FichierIni := TIniFile.Create(OuvrirDialog.FileName) ;
             // restaure
             if (RestaureOreka(FichierIni) = False)
             then
                 Application.MessageBox('Erreur lors de l''enregistrement des param�tres d''Or�ka !',
                                        'Erreur', MB_ICONERROR + MB_OK ) ;
             if (RestaureOrekaFavoris(FichierIni) = False)
             then
                 Application.MessageBox('Erreur lors de l''enregistrement des favoris d''Or�ka !',
                                        'Erreur', MB_ICONERROR + MB_OK ) ;

         end ;
    finally
        OuvrirDialog.Free ;
    end ;
end;

{***************************************************************
 * Fonction qui est appel� pour restaurer les param�tres d'Or�ka
 * dans la base de registre.
 ***************************************************************}
function TForm1.RestaureOreka(FichierIni : TIniFile) : boolean ;
var Registre : TRegistry ;
begin
    RestaureOreka := False ;
    Registre := TRegistry.Create() ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATH)
        then begin
            Registre.WriteString('Login',         FichierIni.ReadString('General', 'Login', '')) ;
            Registre.WriteString('Passwd',        FichierIni.ReadString('General', 'Passwd', '')) ;
            Registre.WriteString('RegisterIDA',   FichierIni.ReadString('General', 'RegisterIDA', '')) ;
            Registre.WriteString('RegisterIDB',   FichierIni.ReadString('General', 'RegisterIDB', '')) ;
            Registre.WriteString('RegisterIDC',   FichierIni.ReadString('General', 'RegisterIDC', '')) ;
            Registre.WriteString('RegisterIDD',   FichierIni.ReadString('General', 'RegisterIDD', '')) ;
            Registre.WriteString('POP3Login',     FichierIni.ReadString('General', 'POP3Login', '')) ;
            Registre.WriteString('POP3Passwd',    FichierIni.ReadString('General', 'POP3Passwd', '')) ;
            Registre.WriteString('POP3Server',    FichierIni.ReadString('General', 'POP3Server', '')) ;
            Registre.WriteString('EMail',         FichierIni.ReadString('General', 'EMail', '')) ;
            Registre.WriteString('MailerPath',    FichierIni.ReadString('General', 'MailerPath', '')) ;
            Registre.WriteString('PagePersoURL',  FichierIni.ReadString('General', 'PagePersoURL', '')) ;
            Registre.WriteString('FistConnexion', FichierIni.ReadString('General', 'FistConnexion', '')) ;
            Registre.WriteString('Sexe',          FichierIni.ReadString('General', 'Sexe', '')) ;
            Registre.WriteString('Zone',          FichierIni.ReadString('General', 'Zone', '')) ;
            Registre.WriteString('TrancheAge',    FichierIni.ReadString('General', 'TrancheAge', '')) ;
            Registre.WriteString('SavePasswd',    FichierIni.ReadString('General', 'SavePasswd', '')) ;
            Registre.WriteString('Modem',         FichierIni.ReadString('General', 'Modem', '')) ;
            Registre.WriteString('ShortCut',      FichierIni.ReadString('General', 'ShortCut', '')) ;

            RestaureOreka := True ;
        end ;
    finally
        Registre.Free ;
    end ;
end ;

{***************************************************************
 * Fonction qui est appel� pour restaurer les favoris d'Or�ka
 * dans la base de registre.
 ***************************************************************}
function TForm1.RestaureOrekaFavoris(FichierIni : TIniFile) : boolean ;
var Registre : TRegistry ;
    i        : integer ;
begin
    RestaureOrekaFavoris := False ;
    Registre := TRegistry.Create() ;
    try
        // d�finit la clef racine
        Registre.RootKey := HKEY_LOCAL_MACHINE ;

        if Registre.OpenKeyReadOnly(OREKAPATH)
        then begin
            for i := 1 to 20 do
            begin
                Registre.WriteString('FavorisUrl'+IntToStr(i),
                                     FichierIni.ReadString('Favoris',
                                     'FavorisUrl'+IntToStr(i), '')) ;
                Registre.WriteString('FavorisMenu'+IntToStr(i),
                                     FichierIni.ReadString('Favoris',
                                     'FavorisMenu'+IntToStr(i), '')) ;
            end ;
            RestaureOrekaFavoris := True ;
        end ;
    finally
        Registre.Free ;
    end ;
end ;

{ C'est la fin ! La suite dans le prochain num�ro !
  Bubule }
end.

