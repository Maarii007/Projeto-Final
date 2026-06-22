<div align="center">

# 🐾 AdotaPet


## 👩‍💻 Desenvolvido por

**Mari** · Engenharia de Software · Unicesumar · 7º período · 2026
*Projeto acadêmico — Programação para Dispositivos Móveis · Unicesumar · 2026*

</div>

---

## 📱 Sobre o projeto

O **AdotaPet** é um aplicativo mobile desenvolvido em Flutter que permite visualizar cães e gatos disponíveis para adoção, salvar favoritos, enviar solicitações de adoção e acompanhar o histórico de solicitações. O projeto aplica **Clean Architecture**, gerenciamento de estado com **Riverpod**, navegação declarativa com **GoRouter**, consumo de API com **Dio**, persistência local com **Drift (SQLite)** e preferências com **SharedPreferences**.

---

## ✨ Funcionalidades

- 🏠 **Home** — grid de animais com busca por raça e filtro por tipo (todos / cães / gatos)
- 🔍 **Detalhe** — foto, nome, raça, origem, temperamento, peso, vida média e descrição
- ❤️ **Favoritos** — salva e remove animais do banco de dados local
- 📋 **Solicitar adoção** — formulário validado com nome, e-mail, telefone e mensagem
- 📜 **Histórico de adoções** — lista todas as solicitações enviadas com data e solicitante
- ⚙️ **Configurações** — troca de tema claro/escuro e filtro padrão de animais
- 🌙 **Tema claro e escuro** — persistido entre sessões via SharedPreferences

---

## 🛠️ Tecnologias e Requisitos Atendidos

| Requisito | Tecnologia | Arquivo |
|-----------|-----------|---------|
| Gerenciamento de estado | `flutter_riverpod ^2.6.1` | `providers.dart` |
| Navegação declarativa | `go_router ^14.0.0` | `app_router.dart` |
| Consumo de API REST | `dio ^5.7.0` | `pet_api_service.dart` |
| Persistência simples | `shared_preferences ^2.3.2` | `prefs.dart` |
| Banco de dados local | `drift ^2.18.0` | `app_database.dart` |
| Clean Architecture | Camadas data/domain/presentation | `features/pets/` |
| Testes unitários (5) | `flutter_test` | `test/unit/` |
| Testes de widget (3) | `flutter_test` | `test/widget/` |
| Teste de integração (1) | `integration_test` | `test/integration/` |

---

## 🌐 APIs Utilizadas

| API | Uso | Autenticação |
|-----|-----|-------------|
| [dog.ceo](https://dog.ceo/dog-api/) | Lista de raças e fotos de cães | Gratuita, sem chave |
| [The Cat API](https://thecatapi.com) | Busca de gatos por nome | Chave gratuita |
| [The Dog API](https://thedogapi.com) | Busca de cães por nome | Chave gratuita |

---

## 🚀 Como executar

### Pré-requisitos

- Flutter SDK `^3.3.0`
- Android Studio ou VS Code
- Dispositivo físico ou emulador Android

### Passo a passo

**1. Clone o repositório**
```bash
git clone https://github.com/seu-usuario/adotapet.git
cd adotapet
```

**2. Crie o arquivo `.env`** na raiz do projeto
```env
DOG_API_KEY=sua_chave_aqui
CAT_API_KEY=sua_chave_aqui
```

**3. Instale as dependências**
```bash
flutter pub get
```

**4. Gere os arquivos do banco (Drift)**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**5. Execute o app**
```bash
flutter run
```

---

## 🧪 Testes

```bash
# Testes unitários e de widget
flutter test

# Teste de integração (requer dispositivo/emulador)
flutter test test/integration/adoption_flow_test.dart
```

### Cobertura dos testes

**Unitários** (`test/unit/pet_unit_test.dart`)
- Conversão `DogModel.fromJson` → `PetEntity`
- Conversão `CatModel.fromJson` → `PetEntity`
- Filtro por tipo de animal (`all` / `dog` / `cat`)
- Busca por raça (case-insensitive)
- Igualdade de `PetEntity` por `id`

**Widget** (`test/widget/pet_widget_test.dart`)
- `PetCard` renderiza nome, raça e tipo corretamente
- `FilterChips` renderiza 3 chips e dispara `onChanged`
- `FavoritesPage` exibe mensagem quando lista está vazia

**Integração** (`test/integration/adoption_flow_test.dart`)
- Fluxo completo: Home → Detalhe → Formulário → Sucesso

---

## 📂 Banco de Dados

O app usa **Drift (SQLite)** com duas tabelas:

**`favoritos`** — animais salvos pelo usuário
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | TEXT (PK) | Identificador único do pet |
| nome | TEXT | Nome da raça |
| raca | TEXT | Nome da raça |
| image_url | TEXT | URL ou path local da imagem |
| tipo | TEXT | `dog` ou `cat` |
| temperamento | TEXT? | Traços de personalidade |
| peso | TEXT? | Faixa de peso em kg |

**`historico_adocoes`** — solicitações enviadas
| Campo | Tipo | Descrição |
|-------|------|-----------|
| pet_id | TEXT | ID do animal |
| pet_nome | TEXT | Nome do animal |
| pet_raca | TEXT | Raça |
| pet_imagem | TEXT | URL da foto |
| pet_tipo | TEXT | `dog` ou `cat` |
| solicitante | TEXT | Nome do adotante |
| email | TEXT | E-mail do adotante |
| data_ms | INTEGER | Timestamp em milliseconds |