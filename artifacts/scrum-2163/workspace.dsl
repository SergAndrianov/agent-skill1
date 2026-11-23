workspace "ПлатиДом" "Поиск и привязка начислений по лицевому счету" {
    !impliedRelationships false

    model {
        client = person "Клиент" "Авторизованный пользователь мобильного банка."
        accrualSource = softwareSystem "ГИС ЖКХ" "Внешний источник начислений ЖКУ. Учебное допущение A-01." "External"

        platidom = softwareSystem "ПлатиДом" "Раздел мобильного банка для регулярных начислений." {
            mobile = container "Мобильное приложение банка" "Поиск, просмотр начислений и подтверждение привязки." "iOS / Android" "MobileDevicePortrait"
            api = container "API ПлатиДома" "Проверяет доступ и реквизиты, запрашивает начисления и управляет привязками." "Java / Spring Boot"
            db = container "База данных ПлатиДома" "Хранит результаты успешных поисков для подтверждения, привязки и последние успешные снимки." "PostgreSQL" "Database"
        }

        client -> mobile "Вводит реквизиты, выбирает сохранённую привязку, просматривает начисления и подтверждает сохранение" "UI"
        mobile -> api "Ищет по реквизитам, читает свои привязки и запрашивает начисления по сохранённой привязке" "HTTPS / JSON" "AccrualQueries"
        mobile -> api "Сохраняет или получает существующую привязку по ID успешного поиска" "HTTPS / JSON" "BindingCommand"
        api -> accrualSource "Запрашивает начисления по поставщику и лицевому счету" "API ГИС ЖКХ · контракт уточнить"
        api -> db "Читает и записывает результаты успешных поисков, привязки и снимки начислений" "SQL / JDBC"
    }

    views {
        container platidom "AccountAccruals" {
            include client mobile api db accrualSource
            title "C4 · Уровень 2 · ПлатиДом — Поиск и привязка начислений по лицевому счету"
            description "Контейнеры и внешние зависимости фичи SCRUM-2163."
            autoLayout tb 420 360
        }

        styles {
            element "Person" {
                shape Person
                background #183153
                color #ffffff
            }
            element "Container" {
                background #1d5681
                color #ffffff
            }
            element "MobileDevicePortrait" {
                shape MobileDevicePortrait
            }
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #526276
                color #ffffff
            }
            relationship "AccrualQueries" {
                style dashed
                position 38
            }
            relationship "BindingCommand" {
                style solid
                position 68
            }
        }
    }
}
