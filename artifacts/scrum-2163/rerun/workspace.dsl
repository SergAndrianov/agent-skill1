workspace "ПлатиДом — поиск и привязка начислений по лицевому счету" "C4 L2 для SCRUM-2163" {
    !impliedRelationships false

    model {
        client = person "Клиент" "Пользователь мобильного банка. Ищет начисления и сохраняет привязки."
        accrualSource = softwareSystem "ГИС ЖКХ" "Источник начислений по поставщику и лицевому счёту (A-01)." "External"
        platidom = softwareSystem "ПлатиДом" "Раздел мобильного банка для регулярных начислений семьи." {
            mobile = container "Мобильное приложение банка" "Принимает реквизиты и подтверждение. Показывает привязки, начисления и ошибки." "iOS / Android" "Mobile"
            api = container "API ПлатиДома" "Проверяет сессию, права и реквизиты. Ищет начисления и сохраняет привязки." "Java / Spring Boot"
            db = container "База данных ПлатиДома" "Хранит привязки клиентов, успешные результаты поиска и время обновления." "PostgreSQL" "Database"
        }

        client -> mobile "Вводит реквизиты или выбирает свою привязку" "Интерфейс приложения"
        client -> mobile "Подтверждает сохранение привязки" "Интерфейс приложения" "Write"
        mobile -> api "Ищет начисления по поставщику и лицевому счёту" "HTTPS/JSON"
        mobile -> api "Читает свои привязки, запрашивает начисления по ID привязки" "HTTPS/JSON"
        mobile -> api "Подтверждает привязку по ID успешного поиска" "HTTPS/JSON" "Write"
        api -> accrualSource "Запрашивает начисления по поставщику и лицевому счёту" "Протокол требует уточнения (A-01, A-14)"
        api -> db "Читает привязки и последние успешные результаты владельца" "SQL/JDBC"
        api -> db "Сохраняет успешный результат поиска или обновления и его время" "SQL/JDBC" "Write"
        api -> db "Создаёт или возвращает привязку по подтверждённому поиску" "SQL/JDBC" "Write"
    }

    views {
        container platidom "SearchAndBind" "Поиск и привязка начислений по лицевому счёту" {
            include *
            title "ПлатиДом — поиск и привязка начислений по лицевому счету (C4 L2)"
            autoLayout tb 420 320
        }

        styles {
            element "Element" {
                width 440
                height 200
                color #ffffff
                fontSize 22
            }
            element "Person" {
                shape Person
                background #164e63
            }
            element "Container" {
                background #1e40af
            }
            element "Mobile" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #475569
            }
            relationship "Relationship" {
                style solid
                color #475569
                fontSize 20
                width 225
            }
            relationship "Write" {
                color #1e40af
            }
        }
    }
}
